library IntravesicalBacillusCalmetteGuerinForBladderCancer version '3.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "ICD10CM": 'urn:oid:2.16.840.1.113883.6.90'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "ActCode": 'urn:oid:2.16.840.1.113883.5.4'

valueset "Active Tuberculosis for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.56'
valueset "BCG Bacillus Calmette Guerin for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.52'
valueset "Bladder Cancer for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.45'
valueset "Chemotherapy for Advanced Cancer": 'urn:oid:2.16.840.1.113883.3.7643.3.1048'
valueset "Cystectomy for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.55'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "HIV": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Immunocompromised Conditions": 'urn:oid:2.16.840.1.113883.3.666.5.1940'
valueset "Immunosuppressive Drugs for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.32'
valueset "Mixed histology urothelial cell carcinoma for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.39'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Unavailability of Bacillus Calmette Guerin for urology care": 'urn:oid:2.16.840.1.113762.1.4.1151.44'

code "Carcinoma in situ of bladder": 'D09.0' from "ICD10CM" display 'Carcinoma in situ of bladder'
code "Combined radiotherapy (procedure)": '169331000' from "SNOMEDCT" display 'Combined radiotherapy (procedure)'
code "T1: Urinary tract tumor invades subepithelial connective tissue (finding)": '369935001' from "SNOMEDCT" display 'T1: Urinary tract tumor invades subepithelial connective tissue (finding)'
code "Ta: Noninvasive papillary carcinoma (urinary tract) (finding)": '369949005' from "SNOMEDCT" display 'Ta: Noninvasive papillary carcinoma (urinary tract) (finding)'
code "Tis: Carcinoma in situ (flat tumor of urinary bladder) (finding)": '369934002' from "SNOMEDCT" display 'Tis: Carcinoma in situ (flat tumor of urinary bladder) (finding)'
code "Tumor staging (tumor staging)": '254292007' from "SNOMEDCT" display 'Tumor staging (tumor staging)'
code "virtual": 'VR' from "ActCode" display 'virtual'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Denominator Exception":
  exists "BCG Not Available Within 6 Months After Bladder Cancer Staging"

define "Numerator":
  "First BCG Administered" is not null

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Has Qualifying Encounter":
  exists ["Encounter, Performed": "Office Visit"] ValidEncounter
    where ValidEncounter.relevantPeriod during "Measurement Period"
      and ValidEncounter.class !~ "virtual"

define "First Bladder Cancer Staging Procedure during Measurement Period":
  "First Bladder Cancer Staging Procedure" FirstBladderCancerStaging
    where Global."NormalizeInterval" ( FirstBladderCancerStaging.relevantDatetime, FirstBladderCancerStaging.relevantPeriod ) during "Measurement Period"

/*Ta High Grade only to be included.  Ta low grade is to be excluded from this measure.*/

define "Has Most Recent Bladder Cancer Tumor Staging is Ta HG, Tis, T1":
  ( "First Bladder Cancer Staging Procedure during Measurement Period" FirstBladderCancerStagingMP
      where FirstBladderCancerStagingMP.result ~ "T1: Urinary tract tumor invades subepithelial connective tissue (finding)"
        or FirstBladderCancerStagingMP.result ~ "Ta: Noninvasive papillary carcinoma (urinary tract) (finding)"
        or FirstBladderCancerStagingMP.result ~ "Tis: Carcinoma in situ (flat tumor of urinary bladder) (finding)"
        or FirstBladderCancerStagingMP.result ~ "Carcinoma in situ of bladder"
  ) is not null

define "Initial Population":
  "First Bladder Cancer Staging Procedure during Measurement Period" is not null
    and "Has Most Recent Bladder Cancer Tumor Staging is Ta HG, Tis, T1"
    and "Has Qualifying Encounter"

define "Bladder Cancer Diagnoses":
  ["Diagnosis": "Bladder Cancer for Urology Care"] BladderCancer
    where BladderCancer.prevalencePeriod starts before 
    end of "Measurement Period"

define "Denominator Exclusion":
  exists "Acute Tuberculosis Diagnosis"
    or exists "Immunosuppressive Drugs"
    or exists "Cystectomy Done"
    or "Has Excluding  HIV, Immunocompromised Conditions or Mixed Histology Before Staging"
    or "Has Excluding Chemotherapy or Radiotherapy Procedure Before Staging"

define "Acute Tuberculosis Diagnosis":
  ["Diagnosis": "Active Tuberculosis for Urology Care"] ActiveTuberculosis
    with "First Bladder Cancer Staging Procedure" FirstBladderCancerStaging
      such that ActiveTuberculosis.prevalencePeriod overlaps after Global."NormalizeInterval" ( FirstBladderCancerStaging.relevantDatetime, FirstBladderCancerStaging.relevantPeriod )

define "BCG Not Available Within 6 Months After Bladder Cancer Staging":
  ( ["Medication, Not Administered": "BCG Bacillus Calmette Guerin for Urology Care"] BCGnotGiven
      with "First Bladder Cancer Staging Procedure" FirstBladderCancerStaging
        such that BCGnotGiven.authorDatetime 6 months or less after start of Global."NormalizeInterval" ( FirstBladderCancerStaging.relevantDatetime, FirstBladderCancerStaging.relevantPeriod )
          and BCGnotGiven.authorDatetime in "Measurement Period"
      where BCGnotGiven.negationRationale in "Unavailability of Bacillus Calmette Guerin for urology care"
  )

define "Cystectomy Done":
  ["Procedure, Performed": "Cystectomy for Urology Care"] Cystectomy
    with "First Bladder Cancer Staging Procedure" FirstBladderCancerStaging
      such that Global.EarliestOf ( Cystectomy.relevantDatetime, Cystectomy.relevantPeriod ) 6 months or less before start of Global."NormalizeInterval" ( FirstBladderCancerStaging.relevantDatetime, FirstBladderCancerStaging.relevantPeriod )

define "Has Excluding  HIV, Immunocompromised Conditions or Mixed Histology Before Staging":
  exists ( ( ["Diagnosis": "HIV"]
      union ["Diagnosis": "Immunocompromised Conditions"]
      union ["Diagnosis": "Mixed histology urothelial cell carcinoma for Urology Care"] ) ExclusionDiagnosis
      with "First Bladder Cancer Staging Procedure" FirstBladderCancerStaging
        such that ExclusionDiagnosis.prevalencePeriod starts on or before start of Global."NormalizeInterval" ( FirstBladderCancerStaging.relevantDatetime, FirstBladderCancerStaging.relevantPeriod )
  )

define "Has Excluding Chemotherapy or Radiotherapy Procedure Before Staging":
  exists ( ( ["Medication, Active": "Chemotherapy for Advanced Cancer"]
      union ["Procedure, Performed": "Combined radiotherapy (procedure)"] ) ExclusionMedsProcedures
      with "First Bladder Cancer Staging Procedure" FirstBladderCancerStaging
        such that ExclusionMedsProcedures.relevantPeriod starts 6 months or less before Global."NormalizeInterval" ( FirstBladderCancerStaging.relevantDatetime, FirstBladderCancerStaging.relevantPeriod )
  )

define "First Bladder Cancer Staging Procedure":
  First(["Procedure, Performed": "Tumor staging (tumor staging)"] BladderCancerStaging
      with "Bladder Cancer Diagnoses" BladderCancer
        such that Global."NormalizeInterval"(BladderCancerStaging.relevantDatetime, BladderCancerStaging.relevantPeriod)starts on or before day of start BladderCancer.prevalencePeriod
          and Global."NormalizeInterval"(BladderCancerStaging.relevantDatetime, BladderCancerStaging.relevantPeriod)overlaps day of BladderCancer.prevalencePeriod
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )

define "First BCG Administered":
  First(["Medication, Administered": "BCG Bacillus Calmette Guerin for Urology Care"] BCG
      with "First Bladder Cancer Staging Procedure" FirstBladderCancerStaging
        such that Global."NormalizeInterval"(BCG.relevantDatetime, BCG.relevantPeriod)starts 6 months or less after start of Global."NormalizeInterval"(FirstBladderCancerStaging.relevantDatetime, FirstBladderCancerStaging.relevantPeriod)
          and Global."NormalizeInterval"(BCG.relevantDatetime, BCG.relevantPeriod)starts during "Measurement Period"
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )

define "Immunosuppressive Drugs":
  ["Medication, Active": "Immunosuppressive Drugs for Urology Care"] ImmunosuppressiveDrugs
    with "First Bladder Cancer Staging Procedure" FirstBladderCancerStaging
      such that Global."NormalizeInterval" ( ImmunosuppressiveDrugs.relevantDatetime, ImmunosuppressiveDrugs.relevantPeriod ) starts on or before start of Global."NormalizeInterval" ( FirstBladderCancerStaging.relevantDatetime, FirstBladderCancerStaging.relevantPeriod )