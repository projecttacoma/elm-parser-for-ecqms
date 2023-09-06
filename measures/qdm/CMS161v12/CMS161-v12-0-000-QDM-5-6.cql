library AdultMajorDepressiveDisorderMDDSuicideRiskAssessment version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Emergency Department Evaluation and Management Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Major Depressive Disorder Active": 'urn:oid:2.16.840.1.113883.3.526.3.1491'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Psych Visit Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
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

define "Numerator":
  "New or Recurrent Major Depressive Disorder Encounter" NewOrRecurrentMDDEncounter
    with ["Intervention, Performed": "Suicide risk assessment (procedure)"] SuicideRiskAssessment
      such that Global."NormalizeInterval" ( SuicideRiskAssessment.relevantDatetime, SuicideRiskAssessment.relevantPeriod ) during NewOrRecurrentMDDEncounter.relevantPeriod

define "Initial Population":
  "New or Recurrent Major Depressive Disorder Encounter" NewOrRecurrentMDDEncounter
    where "AgeInYearsAt"(date from start of "Measurement Period")>= 17

define "New or Recurrent Major Depressive Disorder Encounter":
  "Major Depressive Disorder Encounter" MDDEncounter
    without "Major Depressive Disorder Encounter" PriorMDDEpisodeEncounter
      such that PriorMDDEpisodeEncounter !~ MDDEncounter
        and PriorMDDEpisodeEncounter.relevantPeriod ends 104 days or less before day of start of MDDEncounter.relevantPeriod
    where MDDEncounter.relevantPeriod during "Measurement Period"

define "Major Depressive Disorder Encounter":
  ( ["Encounter, Performed": "Psych Visit Diagnostic Evaluation"]
    union ["Encounter, Performed": "Emergency Department Evaluation and Management Visit"]
    union ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Psych Visit Psychotherapy"]
    union ["Encounter, Performed": "Psychoanalysis"]
    union ["Encounter, Performed": "Telehealth Services"] ) ValidEncounter
    where exists ( ValidEncounter.diagnoses EncounterDiagnosis
        where EncounterDiagnosis.code in "Major Depressive Disorder Active"
    )