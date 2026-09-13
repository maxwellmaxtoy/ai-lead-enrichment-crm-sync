-- =========================================================
-- AI Lead Enrichment & CRM Sync
-- Deduplication Key Migration / Backfill
-- =========================================================


-- =========================================================
-- NORMALIZE EXISTING LEAD DATA
-- =========================================================

update leads
set
    normalized_email =
        lower(trim(email)),

    normalized_company =
        lower(
            regexp_replace(
                trim(company),
                '\s+',
                ' ',
                'g'
            )
        ),

    normalized_website =
        regexp_replace(
            regexp_replace(
                regexp_replace(
                    lower(trim(website)),
                    '^https?://',
                    ''
                ),
                '^www\.',
                ''
            ),
            '/+$',
            ''
        );


-- =========================================================
-- BACKFILL ENVIRONMENT-SAFE DEDUPE KEYS
-- =========================================================

update leads
set
    lead_id_dedupe_key =
        case
            when lead_id is not null
                 and trim(lead_id) <> ''
            then
                upper(
                    coalesce(
                        nullif(trim(run_mode), ''),
                        'PRODUCTION'
                    )
                )
                || '|'
                || lower(trim(lead_id))
            else null
        end,

    email_dedupe_key =
        case
            when normalized_email is not null
                 and trim(normalized_email) <> ''
            then
                upper(
                    coalesce(
                        nullif(trim(run_mode), ''),
                        'PRODUCTION'
                    )
                )
                || '|'
                || normalized_email
            else null
        end,

    company_website_dedupe_key =
        case
            when normalized_company is not null
                 and trim(normalized_company) <> ''
                 and normalized_website is not null
                 and trim(normalized_website) <> ''
            then
                upper(
                    coalesce(
                        nullif(trim(run_mode), ''),
                        'PRODUCTION'
                    )
                )
                || '|'
                || normalized_company
                || '|'
                || normalized_website
            else null
        end;


-- =========================================================
-- UNIQUE INDEXES
-- =========================================================

create unique index if not exists
leads_unique_lead_id_dedupe_key
on leads (lead_id_dedupe_key)
where lead_id_dedupe_key is not null;


create unique index if not exists
leads_unique_email_dedupe_key
on leads (email_dedupe_key)
where email_dedupe_key is not null;


create unique index if not exists
leads_unique_company_website_dedupe_key
on leads (company_website_dedupe_key)
where company_website_dedupe_key is not null;