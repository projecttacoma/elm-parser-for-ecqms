library HFBetaBlockerTherapyforLVSD version '11.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Allergy to Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1177'
valueset "Arrhythmia": 'urn:oid:2.16.840.1.113883.3.526.3.366'
valueset "Asthma": 'urn:oid:2.16.840.1.113883.3.526.3.362'
valueset "Atrioventricular Block": 'urn:oid:2.16.840.1.113883.3.526.3.367'
valueset "Beta Blocker Therapy for LVSD": 'urn:oid:2.16.840.1.113883.3.526.3.1184'
valueset "Beta Blocker Therapy Ingredient": 'urn:oid:2.16.840.1.113883.3.526.3.1493'
valueset "Bradycardia": 'urn:oid:2.16.840.1.113883.3.526.3.412'
valueset "Cardiac Pacer": 'urn:oid:2.16.840.1.113762.1.4.1178.53'
valueset "Cardiac Pacer in Situ": 'urn:oid:2.16.840.1.113883.3.526.3.368'
valueset "Care Services in Long Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Ejection Fraction": 'urn:oid:2.16.840.1.113883.3.526.3.1134'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Heart Failure": 'urn:oid:2.16.840.1.113883.3.526.3.376'
valueset "Heart Rate": 'urn:oid:2.16.840.1.113883.3.526.3.1176'
valueset "Heart Transplant": 'urn:oid:2.16.840.1.113762.1.4.1178.33'
valueset "Heart Transplant Related Diagnoses": 'urn:oid:2.16.840.1.113762.1.4.1178.56'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hypotension": 'urn:oid:2.16.840.1.113883.3.526.3.370'
valueset "Intolerance to Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1178'
valueset "Left Ventricular Assist Device Placement": 'urn:oid:2.16.840.1.113762.1.4.1178.61'
valueset "Left Ventricular Assist Device Related Diagnoses": 'urn:oid:2.16.840.1.113762.1.4.1178.58'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Moderate or Severe": 'urn:oid:2.16.840.1.113883.3.526.3.1092'
valueset "Moderate or Severe LVSD": 'urn:oid:2.16.840.1.113883.3.526.3.1090'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Patient Provider Interaction": 'urn:oid:2.16.840.1.113883.3.526.3.1012'
valueset "Patient Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Left ventricular systolic dysfunction (disorder)": '134401001' from "SNOMEDCT" display 'Left ventricular systolic dysfunction (disorder)'
code "Substance with beta adrenergic receptor antagonist mechanism of action (substance)": '373254001' from "SNOMEDCT" display 'Substance with beta adrenergic receptor antagonist mechanism of action (substance)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Atrioventricular Block without Cardiac Pacer":
  "Has Atrioventricular Block Diagnosis"
    and not "Has Diagnosis of Cardiac Pacer in Situ"
    and not "Has Cardiac Pacer Device Implanted"

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")>= 18
    and Count("Qualifying Encounter During Measurement Period")>= 2
    and exists "Heart Failure Outpatient Encounter"

define "Numerator":
  "Has Beta Blocker Therapy for LVSD Ordered"
    or "Is Currently Taking Beta Blocker Therapy for LVSD"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Denominator Exclusions":
  "Has Heart Transplant"
    or "Has Heart Transplant Related Diagnosis"
    or "Has Left Ventricular Assist Device Implanted"
    or "Has Left Ventricular Assist Device Related Diagnosis"

define "Denominator Exceptions":
  "Has Consecutive Heart Rates Less than 50"
    or "Has Medical or Patient Reason for Not Ordering Beta Blocker for LVSD"
    or "Has Arrhythmia Diagnosis"
    or "Has Hypotension Diagnosis"
    or "Has Asthma Diagnosis"
    or "Has Diagnosis of Allergy or Intolerance to Beta Blocker Therapy"
    or "Has Bradycardia Diagnosis"
    or "Has Allergy or Intolerance to Beta Blocker Therapy Ingredient"
    or "Atrioventricular Block without Cardiac Pacer"

define "Moderate or Severe LVSD Findings":
  ( ["Diagnostic Study, Performed": "Ejection Fraction"] EjectionFraction
      where EjectionFraction.result <= 40 '%'
  )
    union ["Diagnosis": "Moderate or Severe LVSD"]
    union ( ["Diagnosis": "Left ventricular systolic dysfunction (disorder)"] LVSD
        where LVSD.severity in "Moderate or Severe"
    )

define "Qualifying Encounter During Measurement Period":
  ( ["Encounter, Performed": "Care Services in Long Term Residential Facility"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Patient Provider Interaction"] ) ValidEncounter
    where ValidEncounter.relevantPeriod during "Measurement Period"

define "Heart Failure Outpatient Encounter":
  ( ["Encounter, Performed": "Care Services in Long Term Residential Facility"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"] ) QualifyingEncounter
    with ["Diagnosis": "Heart Failure"] HeartFailure
      such that HeartFailure.prevalencePeriod overlaps QualifyingEncounter.relevantPeriod
    where QualifyingEncounter.relevantPeriod during "Measurement Period"

define "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD":
  "Heart Failure Outpatient Encounter" HFOutpatientEncounter
    with "Moderate or Severe LVSD Findings" LVSDFindings
      such that Coalesce(LVSDFindings.prevalencePeriod, Global."NormalizeInterval"(LVSDFindings.relevantDatetime, LVSDFindings.relevantPeriod))starts before 
      end of HFOutpatientEncounter.relevantPeriod

define "Is Currently Taking Beta Blocker Therapy for LVSD":
  exists ["Medication, Active": "Beta Blocker Therapy for LVSD"] ActiveBetaBlocker
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ActiveBetaBlocker.relevantPeriod overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Denominator":
  "Initial Population"
    and exists "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD"

define "Has Allergy or Intolerance to Beta Blocker Therapy Ingredient":
  exists ( ["Allergy/Intolerance": "Beta Blocker Therapy Ingredient"]
    union ["Allergy/Intolerance": "Substance with beta adrenergic receptor antagonist mechanism of action (substance)"] ) BetaBlockerAllergyIntolerance
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that BetaBlockerAllergyIntolerance.prevalencePeriod overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Arrhythmia Diagnosis":
  exists ["Diagnosis": "Arrhythmia"] Arrhythmia
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Arrhythmia.prevalencePeriod overlaps ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Asthma Diagnosis":
  exists ["Diagnosis": "Asthma"] Asthma
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Asthma.prevalencePeriod overlaps ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Atrioventricular Block Diagnosis":
  exists ["Diagnosis": "Atrioventricular Block"] AtrioventricularBlock
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that AtrioventricularBlock.prevalencePeriod overlaps ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Beta Blocker Therapy for LVSD Ordered":
  exists ["Medication, Order": "Beta Blocker Therapy for LVSD"] BetaBlockerOrdered
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that BetaBlockerOrdered.authorDatetime during ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Bradycardia Diagnosis":
  exists ["Diagnosis": "Bradycardia"] Bradycardia
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Bradycardia.prevalencePeriod overlaps ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Cardiac Pacer Device Implanted":
  exists ["Procedure, Performed": "Cardiac Pacer"] ImplantedCardiacPacer
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( ImplantedCardiacPacer.relevantDatetime, ImplantedCardiacPacer.relevantPeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Consecutive Heart Rates Less than 50":
  exists from
    ["Physical Exam, Performed": "Heart Rate"] HeartRate,
    "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
    let PriorHeartRate: Last(["Physical Exam, Performed": "Heart Rate"] MostRecentPriorHeartRate
        where(Global."NormalizeInterval"(MostRecentPriorHeartRate.relevantDatetime, MostRecentPriorHeartRate.relevantPeriod))during ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod
          and(Global."NormalizeInterval"(MostRecentPriorHeartRate.relevantDatetime, MostRecentPriorHeartRate.relevantPeriod))before Global."NormalizeInterval"(HeartRate.relevantDatetime, HeartRate.relevantPeriod)
        sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
    )
    where Global."NormalizeInterval" ( HeartRate.relevantDatetime, HeartRate.relevantPeriod ) during ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod
      and HeartRate.result < 50 '{beats}/min'
      and PriorHeartRate.result < 50 '{beats}/min'

define "Has Diagnosis of Allergy or Intolerance to Beta Blocker Therapy":
  exists ( ["Diagnosis": "Allergy to Beta Blocker Therapy"]
    union ["Diagnosis": "Intolerance to Beta Blocker Therapy"] ) BetaBlockerAllergyOrIntoleranceDiagnosis
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that BetaBlockerAllergyOrIntoleranceDiagnosis.prevalencePeriod overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Diagnosis of Cardiac Pacer in Situ":
  exists ["Diagnosis": "Cardiac Pacer in Situ"] CardiacPacerDiagnosis
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that CardiacPacerDiagnosis.prevalencePeriod overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Heart Transplant":
  exists ["Procedure, Performed": "Heart Transplant"] HeartTransplant
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( HeartTransplant.relevantDatetime, HeartTransplant.relevantPeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Heart Transplant Related Diagnosis":
  exists ["Diagnosis": "Heart Transplant Related Diagnoses"] HeartTransplantCondition
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( HeartTransplantCondition.authorDatetime, HeartTransplantCondition.prevalencePeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Hypotension Diagnosis":
  exists ["Diagnosis": "Hypotension"] Hypotension
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Hypotension.prevalencePeriod overlaps ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Left Ventricular Assist Device Implanted":
  exists ["Procedure, Performed": "Left Ventricular Assist Device Placement"] LVADOutpatient
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( LVADOutpatient.relevantDatetime, LVADOutpatient.relevantPeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Left Ventricular Assist Device Related Diagnosis":
  exists ["Diagnosis": "Left Ventricular Assist Device Related Diagnoses"] LVADCondition
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( LVADCondition.authorDatetime, LVADCondition.prevalencePeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Medical or Patient Reason for Not Ordering Beta Blocker for LVSD":
  exists ["Medication, Not Ordered": "Beta Blocker Therapy for LVSD"] NoBetaBlockerOrdered
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that NoBetaBlockerOrdered.authorDatetime during ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod
    where ( NoBetaBlockerOrdered.negationRationale in "Medical Reason"
        or NoBetaBlockerOrdered.negationRationale in "Patient Reason"
    )