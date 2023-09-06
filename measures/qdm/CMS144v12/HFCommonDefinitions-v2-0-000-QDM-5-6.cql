library HFCommonDefinitions version '2.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96' 

valueset "Care Services in Long Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014' 
valueset "Ejection Fraction": 'urn:oid:2.16.840.1.113883.3.526.3.1134' 
valueset "Heart Failure": 'urn:oid:2.16.840.1.113883.3.526.3.376' 
valueset "Heart Transplant": 'urn:oid:2.16.840.1.113762.1.4.1178.33' 
valueset "Heart Transplant Complications": 'urn:oid:2.16.840.1.113762.1.4.1178.56' 
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016' 
valueset "Left Ventricular Assist Device Complications": 'urn:oid:2.16.840.1.113762.1.4.1178.58' 
valueset "Left Ventricular Assist Device Placement": 'urn:oid:2.16.840.1.113762.1.4.1178.61' 
valueset "Moderate or Severe": 'urn:oid:2.16.840.1.113883.3.526.3.1092' 
valueset "Moderate or Severe LVSD": 'urn:oid:2.16.840.1.113883.3.526.3.1090' 
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012' 
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001' 
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008' 
valueset "Patient Provider Interaction": 'urn:oid:2.16.840.1.113883.3.526.3.1012' 

code "Left ventricular systolic dysfunction (disorder)": '134401001' from "SNOMEDCT" display 'Left ventricular systolic dysfunction (disorder)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Heart Failure Outpatient Encounter":
  ( ["Encounter, Performed": "Care Services in Long Term Residential Facility"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"] ) QualifyingEncounter
    with ["Diagnosis": "Heart Failure"] HeartFailure
      such that HeartFailure.prevalencePeriod overlaps QualifyingEncounter.relevantPeriod
    where QualifyingEncounter.relevantPeriod during day of "Measurement Period"

define "Has Heart Transplant Complications":
  exists ["Diagnosis": "Heart Transplant Complications"] HeartTransplantComplications
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( HeartTransplantComplications.authorDatetime, HeartTransplantComplications.prevalencePeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Left Ventricular Assist Device":
  exists ["Procedure, Performed": "Left Ventricular Assist Device Placement"] LVADOutpatient
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( LVADOutpatient.relevantDatetime, LVADOutpatient.relevantPeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Left Ventricular Assist Device Complications":
  exists ["Diagnosis": "Left Ventricular Assist Device Complications"] LVADComplications
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( LVADComplications.authorDatetime, LVADComplications.prevalencePeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Two Qualifying Outpatient Encounters and Heart Failure Outpatient Encounter During the Measurement Period":
  AgeInYearsAt(date from start of "Measurement Period")>= 18
    and exists ( "Qualifying Outpatient Encounter During Measurement Period" Encounter1
        with "Qualifying Outpatient Encounter During Measurement Period" Encounter2
          such that Encounter2.id !~ Encounter1.id
    )
    and exists "Heart Failure Outpatient Encounter"

define "Has Moderate or Severe LVSD Findings":
  ( ["Diagnostic Study, Performed": "Ejection Fraction"] EjectionFraction
      where EjectionFraction.result <= 40 '%'
  )
    union ["Diagnosis": "Moderate or Severe LVSD"]
    union ( ["Diagnosis": "Left ventricular systolic dysfunction (disorder)"] LVSD
        where LVSD.severity in "Moderate or Severe"
    )

define "Qualifying Outpatient Encounter During Measurement Period":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Care Services in Long Term Residential Facility"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Patient Provider Interaction"] ) ValidEncounter
    where ValidEncounter.relevantPeriod during day of "Measurement Period"

define "Has Heart Transplant":
  exists ["Procedure, Performed": "Heart Transplant"] HeartTransplant
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( HeartTransplant.relevantDatetime, HeartTransplant.relevantPeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD":
  "Heart Failure Outpatient Encounter" HFOutpatientEncounter
    with "Has Moderate or Severe LVSD Findings" LVSDFindings
      such that Coalesce(LVSDFindings.prevalencePeriod, Global."NormalizeInterval"(LVSDFindings.relevantDatetime, LVSDFindings.relevantPeriod))starts before 
      end of HFOutpatientEncounter.relevantPeriod

