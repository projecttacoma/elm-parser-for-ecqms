library HIVViralSuppression version '1.2.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Face-to-Face Interaction": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1048'
valueset "HIV": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "HIV Viral Load": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1002'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "Below threshold level (qualifier value)": '260988000' from "SNOMEDCT" display 'Below threshold level (qualifier value)'
code "Not detected (qualifier value)": '260415000' from "SNOMEDCT" display 'Not detected (qualifier value)'
code "Unlisted preventive medicine service": '99429' from "CPT" display 'Unlisted preventive medicine service'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Initial Population":
  "Has Active HIV Diagnosis Before or in First 90 Days of Measurement Period"
    and "Has Qualifying Encounter During First 240 Days of Measurement Period"

define "Numerator":
  "Most Recent Viral Load Test During Measurement Period".result < 200 '{copies}/mL'
    or "Most Recent Viral Load Test During Measurement Period".result ~ "Below threshold level (qualifier value)"
    or "Most Recent Viral Load Test During Measurement Period".result ~ "Not detected (qualifier value)"

define "Has Qualifying Encounter During First 240 Days of Measurement Period":
  exists ( ( ["Encounter, Performed": "Office Visit"]
      union ["Encounter, Performed": "Outpatient Consultation"]
      union ["Encounter, Performed": "Annual Wellness Visit"]
      union ["Encounter, Performed": "Face-to-Face Interaction"]
      union ["Encounter, Performed": "Home Healthcare Services"]
      union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
      union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
      union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"]
      union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
      union ["Encounter, Performed": "Telephone Visits"]
      union ["Encounter, Performed": "Unlisted preventive medicine service"] ) QualifyingEncounter
      where QualifyingEncounter.relevantPeriod during day of Interval[start of "Measurement Period", start of "Measurement Period" + 240 days]
  )

define "Has Active HIV Diagnosis Before or in First 90 Days of Measurement Period":
  exists ["Diagnosis": "HIV"] HIVDx
    where HIVDx.prevalencePeriod starts before day of ( start of "Measurement Period" + 90 days )

define "Most Recent Viral Load Test During Measurement Period":
  Last(["Laboratory Test, Performed": "HIV Viral Load"] ViralLoad
      where Global."LatestOf"(ViralLoad.relevantDatetime, ViralLoad.relevantPeriod)during day of "Measurement Period"
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )