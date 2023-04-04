library DiabetesMedicalAttentionForNephropathy version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice
include PalliativeCareExclusionECQM version '2.0.000' called PalliativeCare
include AdvancedIllnessandFrailtyExclusionECQM version '7.0.000' called AIFrailLTCF

valueset "ACE Inhibitor or ARB or ARNI": 'urn:oid:2.16.840.1.113883.3.526.3.1139'
valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Diabetes": 'urn:oid:2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "Diabetic Nephropathy": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1004'
valueset "Dialysis Education": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1016'
valueset "Dialysis Services": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1013'
valueset "ESRD Monthly Outpatient Services": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1014'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Glomerulonephritis and Nephrotic Syndrome": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1018'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hypertensive Chronic Kidney Disease": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1017'
valueset "Kidney Failure": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1028'
valueset "Kidney Transplant": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Other Services Related to Dialysis": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1015'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Proteinuria": 'urn:oid:2.16.840.1.113883.3.526.3.1003'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Urine Protein Tests": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1024'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Active ACE or ARB Medications":
  ["Medication, Active": "ACE Inhibitor or ARB or ARNI"] ACEorARBMedication
    where Global."NormalizeInterval" ( ACEorARBMedication.relevantDatetime, ACEorARBMedication.relevantPeriod ) overlaps "Measurement Period"

define "Denominator":
  "Initial Population"

define "End Stage Renal Disease Encounter":
  ["Encounter, Performed": "ESRD Monthly Outpatient Services"]

define "Nephropathy Diagnoses":
  ( ["Diagnosis": "Hypertensive Chronic Kidney Disease"]
    union ["Diagnosis": "Kidney Failure"]
    union ["Diagnosis": "Glomerulonephritis and Nephrotic Syndrome"]
    union ["Diagnosis": "Diabetic Nephropathy"]
    union ["Diagnosis": "Proteinuria"] ) NephropathyDiagnoses
    where NephropathyDiagnoses.prevalencePeriod overlaps "Measurement Period"

define "Numerator":
  exists ( "Active ACE or ARB Medications" )
    or exists ( "Nephropathy Diagnoses" )
    or exists ( "Nephropathy Screenings" )

define "Protein Urea Lab Test":
  ["Laboratory Test, Performed": "Urine Protein Tests"] ProteinUreaResult
    where ProteinUreaResult.result is not null

define "Renal Interventions":
  ["Intervention, Performed": "Other Services Related to Dialysis"]
    union ["Intervention, Performed": "Dialysis Education"]

define "Renal Procedures":
  ( ["Procedure, Performed": "Kidney Transplant"]
      union ["Procedure, Performed": "Dialysis Services"]
  )

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Nephropathy Screenings":
  ( ( "Renal Procedures"
      union "Renal Interventions"
      union "Protein Urea Lab Test" ) ScreeningNephropathy
      where Global."NormalizeInterval" ( ScreeningNephropathy.relevantDatetime, ScreeningNephropathy.relevantPeriod ) during day of "Measurement Period"
  )
    union ( "End Stage Renal Disease Encounter" ESRDEncounter
        where ESRDEncounter.relevantPeriod during day of "Measurement Period"
    )

define "Initial Population":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )in Interval[18, 75]
    and exists ( "Qualifying Encounters" )
    and exists ( ["Diagnosis": "Diabetes"] Diabetes
        where Diabetes.prevalencePeriod overlaps "Measurement Period"
    )

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Annual Wellness Visit"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Telephone Visits"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or AIFrailLTCF."Is Age 66 or Older with Advanced Illness and Frailty"
    or AIFrailLTCF."Is Age 66 or Older Living Long Term in a Nursing Home"
    or PalliativeCare."Palliative Care in the Measurement Period"