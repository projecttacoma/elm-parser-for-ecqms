library HFBetaBlockerTherapyforLVSD version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include HFCommonDefinitions version '2.0.000' called HeartFailure

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
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Heart Rate": 'urn:oid:2.16.840.1.113883.3.526.3.1176'
valueset "Hypotension": 'urn:oid:2.16.840.1.113883.3.526.3.370'
valueset "Intolerance to Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1178'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Substance with beta adrenergic receptor antagonist mechanism of action (substance)": '373254001' from "SNOMEDCT" display 'Substance with beta adrenergic receptor antagonist mechanism of action (substance)'

context Patient

define "Atrioventricular Block without Cardiac Pacer":
  "Has Atrioventricular Block Diagnosis"
    and not "Has Diagnosis of Cardiac Pacer in Situ"
    and not "Has Cardiac Pacer Device Implanted"

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

define "Has Cardiac Pacer Device Implanted":
  exists ["Procedure, Performed": "Cardiac Pacer"] ImplantedCardiacPacer
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( ImplantedCardiacPacer.relevantDatetime, ImplantedCardiacPacer.relevantPeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Is Currently Taking Beta Blocker Therapy for LVSD":
  exists ["Medication, Active": "Beta Blocker Therapy for LVSD"] ActiveBetaBlocker
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ActiveBetaBlocker.relevantPeriod overlaps after day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Hypotension Diagnosis":
  exists ["Diagnosis": "Hypotension"] Hypotension
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Hypotension.prevalencePeriod overlaps day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Diagnosis of Cardiac Pacer in Situ":
  exists ["Diagnosis": "Cardiac Pacer in Situ"] CardiacPacerDiagnosis
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that CardiacPacerDiagnosis.prevalencePeriod overlaps after day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Diagnosis of Allergy or Intolerance to Beta Blocker Therapy":
  exists ( ["Diagnosis": "Allergy to Beta Blocker Therapy"]
    union ["Diagnosis": "Intolerance to Beta Blocker Therapy"] ) BetaBlockerAllergyOrIntoleranceDiagnosis
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that BetaBlockerAllergyOrIntoleranceDiagnosis.prevalencePeriod overlaps after day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Bradycardia Diagnosis":
  exists ["Diagnosis": "Bradycardia"] Bradycardia
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Bradycardia.prevalencePeriod overlaps day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Consecutive Heart Rates Less than 50":
  exists from
    ["Physical Exam, Performed": "Heart Rate"] HeartRate,
    HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
    let PriorHeartRate: Last(["Physical Exam, Performed": "Heart Rate"] MostRecentPriorHeartRate
        where(Global."NormalizeInterval"(MostRecentPriorHeartRate.relevantDatetime, MostRecentPriorHeartRate.relevantPeriod))during ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod
          and(Global."NormalizeInterval"(MostRecentPriorHeartRate.relevantDatetime, MostRecentPriorHeartRate.relevantPeriod))before Global."NormalizeInterval"(HeartRate.relevantDatetime, HeartRate.relevantPeriod)
        sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
    )
    where Global."NormalizeInterval" ( HeartRate.relevantDatetime, HeartRate.relevantPeriod ) during ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod
      and HeartRate.result < 50 '{beats}/min'
      and PriorHeartRate.result < 50 '{beats}/min'

define "Has Allergy or Intolerance to Beta Blocker Therapy Ingredient":
  exists ( ["Allergy/Intolerance": "Beta Blocker Therapy Ingredient"]
    union ["Allergy/Intolerance": "Substance with beta adrenergic receptor antagonist mechanism of action (substance)"] ) BetaBlockerAllergyIntolerance
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that BetaBlockerAllergyIntolerance.prevalencePeriod overlaps after day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Arrhythmia Diagnosis":
  exists ["Diagnosis": "Arrhythmia"] Arrhythmia
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Arrhythmia.prevalencePeriod overlaps day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Asthma Diagnosis":
  exists ["Diagnosis": "Asthma"] Asthma
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Asthma.prevalencePeriod overlaps day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Atrioventricular Block Diagnosis":
  exists ["Diagnosis": "Atrioventricular Block"] AtrioventricularBlock
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that AtrioventricularBlock.prevalencePeriod overlaps day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Beta Blocker Therapy for LVSD Ordered":
  exists ["Medication, Order": "Beta Blocker Therapy for LVSD"] BetaBlockerOrdered
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that BetaBlockerOrdered.authorDatetime during day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Denominator":
  "Initial Population"
    and exists HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD"

define "Denominator Exclusions":
  HeartFailure."Has Heart Transplant"
    or HeartFailure."Has Heart Transplant Complications"
    or HeartFailure."Has Left Ventricular Assist Device"
    or HeartFailure."Has Left Ventricular Assist Device Complications"

define "Has Medical or Patient Reason for Not Ordering Beta Blocker for LVSD":
  exists ["Medication, Not Ordered": "Beta Blocker Therapy for LVSD"] NoBetaBlockerOrdered
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that NoBetaBlockerOrdered.authorDatetime during day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod
    where ( NoBetaBlockerOrdered.negationRationale in "Medical Reason"
        or NoBetaBlockerOrdered.negationRationale in "Patient Reason"
    )

define "Initial Population":
  HeartFailure."Has Two Qualifying Outpatient Encounters and Heart Failure Outpatient Encounter During the Measurement Period"