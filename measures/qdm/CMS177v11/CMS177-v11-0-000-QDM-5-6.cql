library ChildandAdolescentMajorDepressiveDisorderMDDSuicideRiskAssessment version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Group Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1187'
valueset "Major Depressive Disorder Active": 'urn:oid:2.16.840.1.113883.3.526.3.1491'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Psych Visit Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit for Family Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1018'
valueset "Psych Visit Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Psychoanalysis": 'urn:oid:2.16.840.1.113883.3.526.3.1141'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telehealth Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1031'

code "Suicide risk assessment (procedure)": '225337009' from "SNOMEDCT" display 'Suicide risk assessment (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Denominator":
  "Initial Population"

define "Major Depressive Disorder Encounter":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Psych Visit Diagnostic Evaluation"]
    union ["Encounter, Performed": "Psych Visit for Family Psychotherapy"]
    union ["Encounter, Performed": "Psych Visit Psychotherapy"]
    union ["Encounter, Performed": "Psychoanalysis"]
    union ["Encounter, Performed": "Group Psychotherapy"]
    union ["Encounter, Performed": "Telehealth Services"] ) ValidEncounter
    where exists ( ValidEncounter.diagnoses EncounterDiagnosis
        where EncounterDiagnosis.code in "Major Depressive Disorder Active"
    )
      and ValidEncounter.relevantPeriod during "Measurement Period"

define "Initial Population":
  "Major Depressive Disorder Encounter" MDDEncounter
    where "AgeInYearsAt"(date from start of "Measurement Period")>= 6
      and "AgeInYearsAt"(date from start of "Measurement Period")< 17

define "Numerator":
  "Major Depressive Disorder Encounter" MDDEncounter
    with ["Intervention, Performed": "Suicide risk assessment (procedure)"] SuicideRiskAssessment
      such that Global."NormalizeInterval" ( SuicideRiskAssessment.relevantDatetime, SuicideRiskAssessment.relevantPeriod ) during MDDEncounter.relevantPeriod