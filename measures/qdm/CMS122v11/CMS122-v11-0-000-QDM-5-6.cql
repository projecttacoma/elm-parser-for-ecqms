library DiabetesHemoglobinA1cHbA1cPoorControl9 version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include PalliativeCareExclusionECQM version '2.0.000' called PalliativeCare
include Hospice version '4.0.000' called Hospice
include AdvancedIllnessandFrailtyExclusionECQM version '7.0.000' called AIFrailLTCF

codesystem "HCPCS": 'urn:oid:2.16.840.1.113883.6.285'
codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Diabetes": 'urn:oid:2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "HbA1c Laboratory Test": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1013'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Nutrition Services": 'urn:oid:2.16.840.1.113883.3.464.1003.1006'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "Medical nutrition therapy, reassessment and subsequent intervention(s) following second referral in same year for change in diagnosis, medical condition, or treatment regimen (including additional hours needed for renal disease), group (2 or more individuals), each 30 minutes": 'G0271' from "HCPCS" display 'Medical nutrition therapy, reassessment and subsequent intervention(s) following second referral in same year for change in diagnosis, medical condition, or treatment regimen (including additional hours needed for renal disease), group (2 or more individuals), each 30 minutes'
code "Medical nutrition therapy; group (2 or more individual(s)), each 30 minutes": '97804' from "CPT" display 'Medical nutrition therapy; group (2 or more individual(s)), each 30 minutes'
code "Medical nutrition therapy; initial assessment and intervention, individual, face-to-face with the patient, each 15 minutes": '97802' from "CPT" display 'Medical nutrition therapy; initial assessment and intervention, individual, face-to-face with the patient, each 15 minutes'
code "Medical nutrition therapy; re-assessment and intervention, individual, face-to-face with the patient, each 15 minutes": '97803' from "CPT" display 'Medical nutrition therapy; re-assessment and intervention, individual, face-to-face with the patient, each 15 minutes'
code "Medical nutrition therapy; reassessment and subsequent intervention(s) following second referral in same year for change in diagnosis, medical condition or treatment regimen (including additional hours needed for renal disease), individual, face to face with the patient, each 15 minutes": 'G0270' from "HCPCS" display 'Medical nutrition therapy; reassessment and subsequent intervention(s) following second referral in same year for change in diagnosis, medical condition or treatment regimen (including additional hours needed for renal disease), individual, face to face with the patient, each 15 minutes'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Has Most Recent Elevated HbA1c":
  "Most Recent HbA1c".result > 9 '%'

define "Has Most Recent HbA1c Without Result":
  "Most Recent HbA1c" is not null
    and "Most Recent HbA1c".result is null

define "Numerator":
  "Has Most Recent HbA1c Without Result"
    or "Has Most Recent Elevated HbA1c"
    or "Has No Record Of HbA1c"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Most Recent HbA1c":
  Last(["Laboratory Test, Performed": "HbA1c Laboratory Test"] RecentHbA1c
      where Global."LatestOf"(RecentHbA1c.relevantDatetime, RecentHbA1c.relevantPeriod)during day of "Measurement Period"
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or AIFrailLTCF."Is Age 66 or Older with Advanced Illness and Frailty"
    or AIFrailLTCF."Is Age 66 or Older Living Long Term in a Nursing Home"
    or PalliativeCare."Palliative Care in the Measurement Period"

define "Initial Population":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )in Interval[18, 75]
    and exists ( "Qualifying Encounters" )
    and exists ( ["Diagnosis": "Diabetes"] Diabetes
        where Diabetes.prevalencePeriod overlaps "Measurement Period"
    )

define "Has No Record Of HbA1c":
  not exists ["Laboratory Test, Performed": "HbA1c Laboratory Test"] NoHbA1c
    where Global."LatestOf" ( NoHbA1c.relevantDatetime, NoHbA1c.relevantPeriod ) during day of "Measurement Period"

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Annual Wellness Visit"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Nutrition Services"]
    union ["Encounter, Performed": "Medical nutrition therapy; initial assessment and intervention, individual, face-to-face with the patient, each 15 minutes"]
    union ["Encounter, Performed": "Medical nutrition therapy; re-assessment and intervention, individual, face-to-face with the patient, each 15 minutes"]
    union ["Encounter, Performed": "Medical nutrition therapy; group (2 or more individual(s)), each 30 minutes"]
    union ["Encounter, Performed": "Medical nutrition therapy; reassessment and subsequent intervention(s) following second referral in same year for change in diagnosis, medical condition or treatment regimen (including additional hours needed for renal disease), individual, face to face with the patient, each 15 minutes"]
    union ["Encounter, Performed": "Medical nutrition therapy, reassessment and subsequent intervention(s) following second referral in same year for change in diagnosis, medical condition, or treatment regimen (including additional hours needed for renal disease), group (2 or more individuals), each 30 minutes"]
    union ["Encounter, Performed": "Telephone Visits"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"