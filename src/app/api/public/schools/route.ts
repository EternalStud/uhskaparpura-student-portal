import { NextResponse } from "next/server";
import { getSupabaseAdmin } from "@/lib/supabase/server";

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const rawQuery = (searchParams.get("q") || "").trim();
    const cleanQuery = rawQuery.replace(/[%_,()]/g, "").slice(0, 80);

    const supabase = getSupabaseAdmin();
    let query = supabase
      .from("schools")
      .select("udise_code, school_name, school_name_hi, district_name, block_name")
      .eq("status", "ACTIVE")
      .order("school_name", { ascending: true })
      .limit(100);

    if (cleanQuery.length > 0) {
      query = query.or(
        `school_name.ilike.%${cleanQuery}%,school_name_hi.ilike.%${cleanQuery}%,district_name.ilike.%${cleanQuery}%,udise_code.ilike.%${cleanQuery}%`
      );
    }

    const { data, error } = await query;
    if (error) {
      return NextResponse.json(
        { error: "Unable to load schools right now." },
        { status: 500, headers: { "Cache-Control": "no-store" } }
      );
    }

    return NextResponse.json(
      { schools: data ?? [] },
      {
        status: 200,
        headers: {
          "Cache-Control": "public, s-maxage=60, stale-while-revalidate=300",
        },
      }
    );
  } catch {
    return NextResponse.json(
      { error: "Unable to load schools right now." },
      { status: 500, headers: { "Cache-Control": "no-store" } }
    );
  }
}
