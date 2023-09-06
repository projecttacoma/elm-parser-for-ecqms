library AlaraCTIQR version '1.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Calculated CT global noise": '96912-1' from "LOINC" display 'Calculated CT global noise'
code "Calculated CT size-adjusted dose": '96913-9' from "LOINC" display 'Calculated CT size-adjusted dose'
code "CT dose and image quality category": '96914-7' from "LOINC" display 'CT dose and image quality category'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Qualifying Inpatient Encounters":
  ["Encounter, Performed": "Encounter Inpatient"] InpatientEncounter
    where InpatientEncounter.relevantPeriod overlaps "Measurement Period"
      and AgeInYearsAt(start of "Measurement Period")>= 18

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Denominator":
  "Initial Population" IP
    where "Global Noise Value"(IP)is not null
      and "Size Adjusted Value"(IP)is not null
      and IP.result is not null

define "Denominator Exclusion":
  "Denominator" Denom
    where Denom.result.code ~ 'FULLBODY'

define "Numerator":
  "Denominator" Denom
    where "CT Scan Qualifies"(Denom)

define "Initial Population":
  ["Diagnostic Study, Performed": "CT dose and image quality category"] CTScan
    with "Qualifying Inpatient Encounters" InpatientEncounters
      such that Global."NormalizeInterval" ( CTScan.relevantDatetime, CTScan.relevantPeriod ) starts during InpatientEncounters.relevantPeriod
        and Global."NormalizeInterval" ( CTScan.relevantDatetime, CTScan.relevantPeriod ) occurs during "Measurement Period"

define function "Qualifies"(Study "Diagnostic Study, Performed", code String, noiseThreshold Decimal, sizeDoseThreshold Decimal):
  Study.result.code ~ code
    and ( "Global Noise Value"(Study)>= noiseThreshold
        or "Size Adjusted Value"(Study)>= sizeDoseThreshold
    )

define function "CT Scan Qualifies"(IP "Diagnostic Study, Performed"):
  "Qualifies"(IP, 'ABDOPEL LD', 64, 598)
    or "Qualifies"(IP, 'ABDOPEL RT', 29, 644)
    or "Qualifies"(IP, 'ABDOPEL HD', 29, 1260)
    or "Qualifies"(IP, 'CARDIAC LD', 55, 93)
    or "Qualifies"(IP, 'CARDIAC RT', 32, 576)
    or "Qualifies"(IP, 'CHEST LD', 55, 377)
    or "Qualifies"(IP, 'CHEST RT', 49, 377)
    or "Qualifies"(IP, 'CHEST-CARDIAC HD', 49, 1282)
    or "Qualifies"(IP, 'HEAD LD', 115, 582)
    or "Qualifies"(IP, 'HEAD RT', 115, 1025)
    or "Qualifies"(IP, 'HEAD HD', 115, 1832)
    or "Qualifies"(IP, 'EXTREMITIES', 73, 320)
    or "Qualifies"(IP, 'NECK-CSPINE', 25, 1260)
    or "Qualifies"(IP, 'TSPINE-LSPINE', 25, 1260)
    or "Qualifies"(IP, 'CAP', 29, 1637)
    or "Qualifies"(IP, 'TLSPINE', 25, 2520)
    or "Qualifies"(IP, 'HEADNECK RT', 25, 2285)
    or "Qualifies"(IP, 'HEADNECK HD', 25, 3092)

define function "Global Noise Value"(Study "Diagnostic Study, Performed"):
  singleton from ( Study.components C
      where C.code ~ "Calculated CT global noise"
        and C.result.unit = '[hnsf\'U]'
      return C.result.value as Decimal
  )

define function "Size Adjusted Value"(Study "Diagnostic Study, Performed"):
  singleton from ( Study.components C
      where C.code ~ "Calculated CT size-adjusted dose"
        and C.result.unit = 'mGy.cm'
      return C.result.value as Decimal
  )