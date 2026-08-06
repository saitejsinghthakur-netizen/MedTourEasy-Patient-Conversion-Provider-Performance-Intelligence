USE mte_patient_intelligence;

WITH provider_funnel AS (
    SELECT 
        p.provider_id,
        p.provider_name,
        p.region,
        p.specialty_area,
        p.pricing_tier,
        COUNT(j.patient_id) AS total_inquiries,
        SUM(j.consultation_booked) AS total_consultations,
        SUM(j.quote_shared) AS total_quotes,
        SUM(j.treatment_completed) AS total_completed_treatments,
        AVG(j.response_time_hours) AS avg_response_time_hrs,
        AVG(j.satisfaction_score) AS avg_satisfaction_score,
        SUM(CASE WHEN j.response_time_hours > 24 THEN 1 ELSE 0 END) 
            / NULLIF(COUNT(j.patient_id), 0) AS sla_breach_rate
    FROM provider_master p
    LEFT JOIN patient_journey j ON p.provider_id = j.provider_id
    GROUP BY 
        p.provider_id, 
        p.provider_name, 
        p.region, 
        p.specialty_area, 
        p.pricing_tier
),

provider_financials AS (
    SELECT 
        j.provider_id,
        SUM(o.actual_revenue_inr - o.service_cost_inr) AS total_gross_margin_inr,
        AVG(o.actual_revenue_inr - o.service_cost_inr) AS avg_margin_per_treatment
    FROM patient_journey j
    INNER JOIN treatment_outcomes o ON j.patient_id = o.patient_id
    GROUP BY j.provider_id
),

provider_communications AS (
    SELECT 
        p.provider_id,
        SUM(CASE WHEN cl.follow_up_status = 'Completed' THEN 1 ELSE 0 END) 
            / NULLIF(COUNT(cl.communication_id), 0) AS follow_up_completion_rate
    FROM provider_master p
    LEFT JOIN communication_logs cl ON p.provider_id = cl.provider_id
    GROUP BY p.provider_id
),

scorecard_base AS (
    SELECT 
        pf.provider_id,
        pf.provider_name,
        pf.region,
        pf.specialty_area,
        pf.pricing_tier,
        pf.total_inquiries,
        pf.total_completed_treatments,
        ROUND((pf.total_consultations / NULLIF(pf.total_inquiries, 0)) * 100, 2) AS consultation_conversion_pct,
        ROUND((pf.total_completed_treatments / NULLIF(pf.total_inquiries, 0)) * 100, 2) AS treatment_completion_pct,
        ROUND((pf.total_completed_treatments / NULLIF(pf.total_quotes, 0)) * 100, 2) AS quote_to_treatment_pct,
        ROUND(pf.avg_response_time_hrs, 2) AS avg_response_time_hrs,
        ROUND(pf.sla_breach_rate * 100, 2) AS sla_breach_pct,
        ROUND(COALESCE(pc.follow_up_completion_rate, 0) * 100, 2) AS follow_up_completion_pct,
        ROUND(COALESCE(pf.avg_satisfaction_score, 0), 2) AS avg_satisfaction_score,
        COALESCE(fin.total_gross_margin_inr, 0) AS total_gross_margin_inr,
        NTILE(100) OVER (ORDER BY COALESCE(fin.total_gross_margin_inr, 0) ASC) AS margin_percentile
    FROM provider_funnel pf
    LEFT JOIN provider_financials fin ON pf.provider_id = fin.provider_id
    LEFT JOIN provider_communications pc ON pf.provider_id = pc.provider_id
),

scored_providers AS (
    SELECT 
        provider_id,
        provider_name,
        region,
        specialty_area,
        pricing_tier,
        total_inquiries,
        total_completed_treatments,
        treatment_completion_pct,
        quote_to_treatment_pct,
        sla_breach_pct,
        follow_up_completion_pct,
        avg_satisfaction_score,
        total_gross_margin_inr,
        ROUND(
            (treatment_completion_pct * 0.30) + 
            ((100 - sla_breach_pct) * 0.20) + 
            (follow_up_completion_pct * 0.20) + 
            ((avg_satisfaction_score / 10.0 * 100) * 0.15) + 
            (margin_percentile * 0.15), 
        2) AS provider_intelligence_score
    FROM scorecard_base
)

SELECT 
    provider_id,
    provider_name,
    region,
    specialty_area,
    pricing_tier,
    total_inquiries,
    total_completed_treatments,
    treatment_completion_pct,
    quote_to_treatment_pct,
    sla_breach_pct,
    follow_up_completion_pct,
    avg_satisfaction_score,
    total_gross_margin_inr,
    provider_intelligence_score,
    DENSE_RANK() OVER (ORDER BY provider_intelligence_score DESC) AS provider_rank
FROM scored_providers
ORDER BY provider_rank ASC;