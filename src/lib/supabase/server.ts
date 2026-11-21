import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import type { Database } from '@/types/database';

/**
 * Server-only Supabase admin client using SUPABASE_SERVICE_ROLE_KEY over HTTPS PostgREST.
 * NEVER import this module from a `'use client'` component.
 */

if (typeof window !== 'undefined') {
  throw new Error('SECURITY: src/lib/supabase/server.ts cannot be executed in a browser context.');
}

// Adapts TypeScript interfaces in Database['public']['Tables'] to mapped object types
// that satisfy `@supabase/postgrest-js` GenericTable (`Record<string, unknown>`).
type AsRecord<T> = { [K in keyof T]: T[K] };
type AdaptTables<T> = {
  [TableName in keyof T]: T[TableName] extends {
    Row: infer R;
    Insert: infer I;
    Update: infer U;
    Relationships: infer Rel;
  }
    ? {
        Row: AsRecord<R>;
        Insert: AsRecord<I>;
        Update: AsRecord<U>;
        Relationships: Rel;
      }
    : never;
};

export type SupabaseDatabase = {
  public: {
    Tables: AdaptTables<Database['public']['Tables']>;
    Views: Database['public']['Views'];
    Functions: Database['public']['Functions'];
    Enums: Database['public']['Enums'];
    CompositeTypes: Database['public']['CompositeTypes'];
  };
};

let cachedAdminClient: SupabaseClient<SupabaseDatabase> | null = null;

function resolveSupabaseServerConfig(): { url: string; serviceRoleKey: string } {
  const url = (process.env.SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL || '').trim();
  const serviceRoleKey = (process.env.SUPABASE_SERVICE_ROLE_KEY || '').trim();

  if (!url) {
    throw new Error('Missing NEXT_PUBLIC_SUPABASE_URL (or SUPABASE_URL) environment variable.');
  }
  if (!serviceRoleKey) {
    throw new Error('Missing SUPABASE_SERVICE_ROLE_KEY environment variable.');
  }

  let parsed: URL;
  try {
    parsed = new URL(url);
  } catch {
    throw new Error('Invalid Supabase URL configured in environment.');
  }

  const isLocal =
    parsed.hostname === 'localhost' ||
    parsed.hostname === '127.0.0.1' ||
    parsed.hostname === '::1';

  if (parsed.protocol !== 'https:' && !isLocal) {
    throw new Error('SECURITY: Supabase server URL must use HTTPS in non-local environments.');
  }

  return { url: parsed.origin, serviceRoleKey };
}

/**
 * Returns a memoized server-only Supabase admin client backed by the
 * `service_role` key with session persistence completely disabled.
 */
export function getSupabaseAdmin(): SupabaseClient<SupabaseDatabase> {
  if (typeof window !== 'undefined') {
    throw new Error('SECURITY: getSupabaseAdmin() is strictly server-only.');
  }
  if (!cachedAdminClient) {
    const { url, serviceRoleKey } = resolveSupabaseServerConfig();
    cachedAdminClient = createClient<SupabaseDatabase>(url, serviceRoleKey, {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
        detectSessionInUrl: false,
      },
      global: {
        headers: {
          'X-Client-Info': 'students-of-bihar-server/2.4',
        },
      },
    });
  }
  return cachedAdminClient;
}

/**
 * Alias for `getSupabaseAdmin()` for routes preferring factory naming.
 */
export function createAdminClient(): SupabaseClient<SupabaseDatabase> {
  return getSupabaseAdmin();
}
