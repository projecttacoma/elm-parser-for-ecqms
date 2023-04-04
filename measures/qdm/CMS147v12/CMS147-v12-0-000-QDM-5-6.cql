library PreventiveCareandScreeningInfluenzaImmunization version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice

codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Care Services in Long Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Discharge Services Nursing Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1013'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hemodialysis": 'urn:oid:2.16.840.1.113883.3.526.3.1083'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Influenza Vaccination": 'urn:oid:2.16.840.1.113883.3.526.3.402'
valueset "Influenza Vaccine": 'urn:oid:2.16.840.1.113883.3.526.3.1254'
valueset "Influenza Virus LAIV Immunization": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1087'
valueset "Influenza Virus LAIV Procedure": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1088'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Patient Provider Interaction": 'urn:oid:2.16.840.1.113883.3.526.3.1012'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Peritoneal Dialysis": 'urn:oid:2.16.840.1.113883.3.526.3.1084'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Group Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "Office or other outpatient visit for the evaluation and management of an established patient, that may not require the presence of a physician or other qualified health care professional. Usually, the presenting problem(s) are minimal.": '99211' from "CPT" display 'Office or other outpatient visit for the evaluation and management of an established patient, that may not require the presence of a physician or other qualified health care professional. Usually, the presenting problem(s) are minimal.'
code "Unlisted preventive medicine service": '99429' from "CPT" display 'Unlisted preventive medicine service'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"
    and ( exists "Encounter During Influenza Season"
        or exists "Hemodialysis During Influenza Season"
        or exists "Peritoneal Dialysis During Influenza Season"
    )

define "Denominator Exclusions":
  Hospice."Has Hospice Services"

define "Hemodialysis During Influenza Season":
  ["Procedure, Performed": "Hemodialysis"] FluSeasonHemodialysis
    where Global."NormalizeInterval" ( FluSeasonHemodialysis.relevantDatetime, FluSeasonHemodialysis.relevantPeriod ) overlaps "Influenza Season"

define "Hemodialysis During Measurement Period":
  ["Procedure, Performed": "Hemodialysis"] Hemodialysis
    where Global."NormalizeInterval" ( Hemodialysis.relevantDatetime, Hemodialysis.relevantPeriod ) overlaps "Measurement Period"

define "Influenza Season":
  Interval[start of "Measurement Period" - 3 months, start of "Measurement Period" + 3 months )

define "Influenza Vaccination Procedure":
  ( ["Procedure, Performed": "Influenza Vaccination"]
    union ["Procedure, Performed": "Influenza Virus LAIV Procedure"] ) FluVaccination
    where Global."NormalizeInterval" ( FluVaccination.relevantDatetime, FluVaccination.relevantPeriod ) during day of "Between July 1 of the Year Prior to the Measurement Period and June 30 of the Measurement Period"

define "Numerator":
  exists "Influenza Vaccination Procedure"
    or exists "Influenza Immunization Administered"

define "Peritoneal Dialysis During Influenza Season":
  ["Procedure, Performed": "Peritoneal Dialysis"] FluSeasonPeritonealDialysis
    where Global."NormalizeInterval" ( FluSeasonPeritonealDialysis.relevantDatetime, FluSeasonPeritonealDialysis.relevantPeriod ) overlaps "Influenza Season"

define "Peritoneal Dialysis During Measurement Period":
  ["Procedure, Performed": "Peritoneal Dialysis"] PeritonealDialysis
    where Global."NormalizeInterval" ( PeritonealDialysis.relevantDatetime, PeritonealDialysis.relevantPeriod ) overlaps "Measurement Period"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Encounter During Influenza Season":
  ( ["Encounter, Performed": "Annual Wellness Visit"]
    union ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Care Services in Long Term Residential Facility"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Unlisted preventive medicine service"]
    union ["Encounter, Performed": "Preventive Care Services Group Counseling"]
    union ["Encounter, Performed": "Preventive Care Services Individual Counseling"]
    union ["Encounter, Performed": "Discharge Services Nursing Facility"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"] ) FluEncounter
    where FluEncounter.relevantPeriod starts during day of "Influenza Season"

define "Qualifying Encounters During Measurement Period":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Care Services in Long Term Residential Facility"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Patient Provider Interaction"]
    union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services Individual Counseling"]
    union ["Encounter, Performed": "Preventive Care Services Group Counseling"]
    union ["Encounter, Performed": "Unlisted preventive medicine service"]
    union ["Encounter, Performed": "Discharge Services Nursing Facility"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Annual Wellness Visit"]
    union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Office or other outpatient visit for the evaluation and management of an established patient, that may not require the presence of a physician or other qualified health care professional. Usually, the presenting problem(s) are minimal."]
    union ["Encounter, Performed": "Online Assessments"]
    union ["Encounter, Performed": "Telephone Visits"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"

define "Initial Population":
  AgeInMonthsAt(date from start of "Measurement Period")>= 6
    and ( exists "Qualifying Encounters During Measurement Period"
        or exists "Hemodialysis During Measurement Period"
        or exists "Peritoneal Dialysis During Measurement Period"
    )

define "Between July 1 of the Year Prior to the Measurement Period and June 30 of the Measurement Period":
  Interval[start of "Measurement Period" - 6 months, start of "Measurement Period" + 6 months )

define "Influenza Immunization Administered":
  ( ["Immunization, Administered": "Influenza Vaccine"]
    union ["Immunization, Administered": "Influenza Virus LAIV Immunization"] ) AdministeredFluVaccine
    where AdministeredFluVaccine.relevantDatetime during day of "Between July 1 of the Year Prior to the Measurement Period and June 30 of the Measurement Period"