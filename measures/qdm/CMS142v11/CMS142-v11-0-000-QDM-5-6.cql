library DRCommunicationWithPhysicianManagingDiabetes version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "ActCode": 'urn:oid:2.16.840.1.113883.5.4'

valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Diabetic Retinopathy": 'urn:oid:2.16.840.1.113883.3.526.3.327'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Level of Severity of Retinopathy Findings": 'urn:oid:2.16.840.1.113883.3.526.3.1283'
valueset "Macular Edema Findings Present": 'urn:oid:2.16.840.1.113883.3.526.3.1320'
valueset "Macular Exam": 'urn:oid:2.16.840.1.113883.3.526.3.1251'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Ophthalmological Services": 'urn:oid:2.16.840.1.113883.3.526.3.1285'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Patient Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Macular edema absent (situation)": '428341000124108' from "SNOMEDCT" display 'Macular edema absent (situation)'
code "virtual": 'VR' from "ActCode" display 'virtual'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"
    and exists "Macular Exam Performed"

define "Denominator Exceptions":
  exists "Medical or Patient Reason for Not Communicating Level of Severity of Retinopathy"
    or exists "Medical or Patient Reason for Not Communicating Absence of Macular Edema"
    or exists "Medical or Patient Reason for Not Communicating Presence of Macular Edema"

define "Diabetic Retinopathy Encounter":
  "Qualifying Encounter During Measurement Period" ValidQualifyingEncounter
    with ["Diagnosis": "Diabetic Retinopathy"] DiabeticRetinopathy
      such that DiabeticRetinopathy.prevalencePeriod overlaps ValidQualifyingEncounter.relevantPeriod

define "Level of Severity of Retinopathy Findings Communicated":
  ["Communication, Performed": "Level of Severity of Retinopathy Findings"] LevelOfSeverityCommunicated
    with "Diabetic Retinopathy Encounter" EncounterDiabeticRetinopathy
      such that LevelOfSeverityCommunicated.sentDatetime after start of EncounterDiabeticRetinopathy.relevantPeriod

define "Macular Edema Absence Communicated":
  ["Communication, Performed": "Macular edema absent (situation)"] MacularEdemaAbsentCommunicated
    with "Diabetic Retinopathy Encounter" EncounterDiabeticRetinopathy
      such that MacularEdemaAbsentCommunicated.sentDatetime after start of EncounterDiabeticRetinopathy.relevantPeriod

define "Macular Edema Presence Communicated":
  ["Communication, Performed": "Macular Edema Findings Present"] MacularEdemaPresentCommunicated
    with "Diabetic Retinopathy Encounter" EncounterDiabeticRetinopathy
      such that MacularEdemaPresentCommunicated.sentDatetime after start of EncounterDiabeticRetinopathy.relevantPeriod

define "Macular Exam Performed":
  ["Diagnostic Study, Performed": "Macular Exam"] MacularExam
    with "Diabetic Retinopathy Encounter" EncounterDiabeticRetinopathy
      such that Global."NormalizeInterval" ( MacularExam.relevantDatetime, MacularExam.relevantPeriod ) during EncounterDiabeticRetinopathy.relevantPeriod
    where MacularExam.result is not null

define "Medical or Patient Reason for Not Communicating Absence of Macular Edema":
  ["Communication, Not Performed": "Macular edema absent (situation)"] MacularEdemaAbsentNotCommunicated
    with "Diabetic Retinopathy Encounter" EncounterDiabeticRetinopathy
      such that MacularEdemaAbsentNotCommunicated.authorDatetime during EncounterDiabeticRetinopathy.relevantPeriod
    where ( MacularEdemaAbsentNotCommunicated.negationRationale in "Medical Reason"
        or MacularEdemaAbsentNotCommunicated.negationRationale in "Patient Reason"
    )

define "Medical or Patient Reason for Not Communicating Level of Severity of Retinopathy":
  ["Communication, Not Performed": "Level of Severity of Retinopathy Findings"] LevelOfSeverityNotCommunicated
    with "Diabetic Retinopathy Encounter" EncounterDiabeticRetinopathy
      such that LevelOfSeverityNotCommunicated.authorDatetime during EncounterDiabeticRetinopathy.relevantPeriod
    where ( LevelOfSeverityNotCommunicated.negationRationale in "Medical Reason"
        or LevelOfSeverityNotCommunicated.negationRationale in "Patient Reason"
    )

define "Medical or Patient Reason for Not Communicating Presence of Macular Edema":
  ["Communication, Not Performed": "Macular Edema Findings Present"] MacularEdemaPresentNotCommunicated
    with "Diabetic Retinopathy Encounter" EncounterDiabeticRetinopathy
      such that MacularEdemaPresentNotCommunicated.authorDatetime during EncounterDiabeticRetinopathy.relevantPeriod
    where ( MacularEdemaPresentNotCommunicated.negationRationale in "Medical Reason"
        or MacularEdemaPresentNotCommunicated.negationRationale in "Patient Reason"
    )

define "Numerator":
  exists "Level of Severity of Retinopathy Findings Communicated"
    and ( exists "Macular Edema Absence Communicated"
        or exists "Macular Edema Presence Communicated"
    )

define "Qualifying Encounter During Measurement Period":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Ophthalmological Services"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Care Services in Long-Term Residential Facility"]
    union ["Encounter, Performed": "Nursing Facility Visit"] ) QualifyingEncounter
    where QualifyingEncounter.relevantPeriod during "Measurement Period"
      and QualifyingEncounter.class !~ "virtual"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")>= 18
    and exists "Diabetic Retinopathy Encounter"