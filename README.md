# MedTourEasy Patient Conversion Intelligence

## Overview
This repository contains end-to-end data analytics, SQL scorecards, machine learning drop-off modeling, patient segmentation, and executive reporting for the MedTourEasy Patient Intelligence Platform. The objective is to optimize patient conversion, identify funnel drop-off drivers, evaluate provider performance, and deliver actionable strategic recommendations.

---

## Repository Structure
```text
.
├── 01_data_quality_report.ipynb          # Data cleaning, null checks, schema validation
├── 02_exploratory_patient_funnel_analysis.ipynb # Funnel conversion & drop-off analysis
├── 03_sql_provider_scorecard.sql        # SQL analysis for hospital/provider performance
├── 04_modeling_dropoff_and_completion.ipynb     # Predictive models for patient completion/drop-off
├── 05_segmentation_and_recommendations.ipynb    # Patient clustering, segmentation & PRD memo
├── provider_scorecard_output.csv        # Query output from SQL provider scorecard
├── patient_journey.csv / .db             # Primary dataset (SQLite database & CSV exports)
├── MedTourEasy_Patient_Analytics_Master.xlsx    # Executive reporting workbook
├── Final Tableau Sheets.twbx            # Tableau dashboard package
├── requirements.txt                     # Python dependencies
└── README.md                            # Documentation and setup instructions
```

---

## Final PRD-Style Analytics Memo

### 1. Problem Statement
MedTourEasy experiences high patient drop-offs across various stages of the medical tourism funnel. The goal is to identify bottlenecks, improve first-response SLAs, measure provider quality, and optimize revenue realization.

### 2. Analytical Approach & Methodology
- **Data Quality & Audit**: Standardized schema, validated dates, handled missing data, and flagged outliers.
- **Funnel & Exploratory Analysis**: Evaluated conversion rates across stages (Inquiry $
ightarrow$ Consultation $
ightarrow$ Quote $
ightarrow$ Treatment).
- **Provider Performance**: Built SQL metrics evaluating response latency, conversion efficiency, and satisfaction index.
- **Predictive Modeling**: Applied ML algorithms (Logistic Regression / Random Forest) to predict drop-off risk factors.
- **Segmentation**: Clustered patient demographics, medical urgency, and budget bands to deliver targeted interventions.

### 3. Key Findings
- **Response Delay Impact**: Delayed initial response (>12 hours) significantly increases drop-off rate prior to consultation booking.
- **Provider Heterogeneity**: Top-tier providers exhibit higher conversion rates due to dedicated international patient desks and quicker response times.
- **Drop-off Bottlenecks**: The largest attrition occurs between consultation booking and quote acceptance due to pricing transparency issues and lead times.

### 4. Strategic Recommendations
- **Automated Routing & SLAs**: Enforce strict 4-hour SLA response windows using multi-channel routing (WhatsApp/Email).
- **Tiered Provider Network**: Prioritize high-performing hospital providers with proven conversion tracks.
- **Dynamic Follow-Ups**: Deploy predictive automated triggers for patients with high risk scores.

### 5. Key Risks & Mitigation
- **Data Leakage / Privacy**: Ensure compliance with health data regulation standards.
- **Provider Alignment**: Offer incentive structures for hospital partners meeting target conversion metrics.

---

## Reproducibility & Setup Instructions

### Prerequisites
- Python 3.8+
- SQLite3
- Jupyter Notebook / JupyterLab

### Installation
1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run Jupyter Notebooks in sequential order (`01` through `05`).
