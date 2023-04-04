library PreventiveCareAndScreeningTobaccoUseScreeningAndCessationIntervention version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice

codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'
codesystem "ICD10CM": 'urn:oid:2.16.840.1.113883.6.90'

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Nutrition Services": 'urn:oid:2.16.840.1.113883.3.464.1003.1006'
valueset "Occupational Therapy Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1011'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Ophthalmological Services": 'urn:oid:2.16.840.1.113883.3.526.3.1285'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Physical Therapy Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1022'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Group Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Psych Visit Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Psychoanalysis": 'urn:oid:2.16.840.1.113883.3.526.3.1141'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Speech and Hearing Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1530'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Tobacco Non User": 'urn:oid:2.16.840.1.113883.3.526.3.1189'
valueset "Tobacco Use Cessation Counseling": 'urn:oid:2.16.840.1.113883.3.526.3.509'
valueset "Tobacco Use Cessation Pharmacotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1190'
valueset "Tobacco Use Screening": 'urn:oid:2.16.840.1.113883.3.526.3.1278'
valueset "Tobacco User": 'urn:oid:2.16.840.1.113883.3.526.3.1170'

code "Health behavior assessment, or re-assessment (ie, health-focused clinical interview, behavioral observations, clinical decision making)": '96156' from "CPT" display 'Health behavior assessment, or re-assessment (ie, health-focused clinical interview, behavioral observations, clinical decision making)'
code "Health behavior intervention, individual, face-to-face; initial 30 minutes": '96158' from "CPT" display 'Health behavior intervention, individual, face-to-face; initial 30 minutes'
code "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure": '99024' from "CPT" display 'Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure'
code "Tobacco abuse counseling": 'Z71.6' from "ICD10CM" display 'Tobacco abuse counseling'
code "Unlisted preventive medicine service": '99429' from "CPT" display 'Unlisted preventive medicine service'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Active Pharmacotherapy for Tobacco Cessation":
  ["Medication, Active": "Tobacco Use Cessation Pharmacotherapy"] TakingCessationPharmacotherapy
    where Global."NormalizeInterval" ( TakingCessationPharmacotherapy.relevantDatetime, TakingCessationPharmacotherapy.relevantPeriod ) during day of Interval[start of "Measurement Period" - 6 months, 
    end of "Measurement Period"]

define "Denominator 1":
  "Initial Population"

define "Denominator 2":
  "Initial Population"
    and "Most Recent Tobacco Use Screening Indicates Tobacco User" is not null

define "Denominator 3":
  "Initial Population"

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")>= 18
    and ( Count("Qualifying Visit During Measurement Period")>= 2
        or exists "Preventive Visit During Measurement Period"
    )

define "Numerator 1":
  "Most Recent Tobacco Use Screening Indicates Tobacco Non User" is not null
    or "Most Recent Tobacco Use Screening Indicates Tobacco User" is not null

define "Numerator 2":
  exists "Tobacco Cessation Counseling Given"
    or exists "Tobacco Cessation Pharmacotherapy Ordered"
    or exists "Active Pharmacotherapy for Tobacco Cessation"

define "Numerator 3":
  "Most Recent Tobacco Use Screening Indicates Tobacco Non User" is not null
    or ( "Most Recent Tobacco Use Screening Indicates Tobacco User" is not null
        and ( exists "Tobacco Cessation Counseling Given"
            or exists "Tobacco Cessation Pharmacotherapy Ordered"
            or exists "Active Pharmacotherapy for Tobacco Cessation"
        )
    )

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Most Recent Tobacco Use Screening Indicates Tobacco Non User":
  ( Last(["Assessment, Performed": "Tobacco Use Screening"] TobaccoUseScreening
      where Global."NormalizeInterval"(TobaccoUseScreening.relevantDatetime, TobaccoUseScreening.relevantPeriod)during "Measurement Period"
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )) MostRecentTobaccoUseScreening
    where MostRecentTobaccoUseScreening.result in "Tobacco Non User"

define "Most Recent Tobacco Use Screening Indicates Tobacco User":
  ( Last(["Assessment, Performed": "Tobacco Use Screening"] TobaccoUseScreening
      where Global."NormalizeInterval"(TobaccoUseScreening.relevantDatetime, TobaccoUseScreening.relevantPeriod)during "Measurement Period"
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )) MostRecentTobaccoUseScreening
    where MostRecentTobaccoUseScreening.result in "Tobacco User"

define "Tobacco Cessation Pharmacotherapy Ordered":
  ["Medication, Order": "Tobacco Use Cessation Pharmacotherapy"] CessationPharmacotherapyOrdered
    where CessationPharmacotherapyOrdered.authorDatetime during day of Interval[start of "Measurement Period" - 6 months, 
    end of "Measurement Period"]

define "Tobacco Cessation Counseling Given":
  ( ["Intervention, Performed": "Tobacco Use Cessation Counseling"] TobaccoCessationCounseling
      where Global."NormalizeInterval" ( TobaccoCessationCounseling.relevantDatetime, TobaccoCessationCounseling.relevantPeriod ) during day of Interval[start of "Measurement Period" - 6 months, 
      end of "Measurement Period"]
  )
    union ( ["Diagnosis": "Tobacco abuse counseling"] TobaccoCounseling
        where ( TobaccoCounseling.prevalencePeriod ) starts during day of Interval[start of "Measurement Period" - 6 months, 
        end of "Measurement Period"]
    )

define "Preventive Visit During Measurement Period":
  ( ["Encounter, Performed": "Annual Wellness Visit"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services Group Counseling"]
    union ["Encounter, Performed": "Unlisted preventive medicine service"]
    union ["Encounter, Performed": "Preventive Care Services Individual Counseling"]
    union ["Encounter, Performed": "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure"]
    union ["Encounter, Performed": "Nutrition Services"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"] ) PreventiveEncounter
    where PreventiveEncounter.relevantPeriod during day of "Measurement Period"

define "Qualifying Visit During Measurement Period":
  ( ["Encounter, Performed": "Health behavior intervention, individual, face-to-face; initial 30 minutes"]
    union ["Encounter, Performed": "Health behavior assessment, or re-assessment (ie, health-focused clinical interview, behavioral observations, clinical decision making)"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Occupational Therapy Evaluation"]
    union ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Ophthalmological Services"]
    union ["Encounter, Performed": "Physical Therapy Evaluation"]
    union ["Encounter, Performed": "Psych Visit Diagnostic Evaluation"]
    union ["Encounter, Performed": "Psych Visit Psychotherapy"]
    union ["Encounter, Performed": "Psychoanalysis"]
    union ["Encounter, Performed": "Speech and Hearing Evaluation"]
    union ["Encounter, Performed": "Telephone Visits"]
    union ["Encounter, Performed": "Online Assessments"] ) OfficeBasedEncounter
    where OfficeBasedEncounter.relevantPeriod during day of "Measurement Period"

define "Denominator Exclusion":
  Hospice."Has Hospice Services"