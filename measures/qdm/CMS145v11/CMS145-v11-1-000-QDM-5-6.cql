library CADBetaBlockerTherapyPriorMIorLVSD version '11.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Allergy to Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1177'
valueset "Arrhythmia": 'urn:oid:2.16.840.1.113883.3.526.3.366'
valueset "Asthma": 'urn:oid:2.16.840.1.113883.3.526.3.362'
valueset "Atrioventricular Block": 'urn:oid:2.16.840.1.113883.3.526.3.367'
valueset "Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1174'
valueset "Beta Blocker Therapy for LVSD": 'urn:oid:2.16.840.1.113883.3.526.3.1184'
valueset "Beta Blocker Therapy Ingredient": 'urn:oid:2.16.840.1.113883.3.526.3.1493'
valueset "Bradycardia": 'urn:oid:2.16.840.1.113883.3.526.3.412'
valueset "Cardiac Pacer": 'urn:oid:2.16.840.1.113762.1.4.1178.53'
valueset "Cardiac Pacer in Situ": 'urn:oid:2.16.840.1.113883.3.526.3.368'
valueset "Cardiac Surgery": 'urn:oid:2.16.840.1.113883.3.526.3.371'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Coronary Artery Disease No MI": 'urn:oid:2.16.840.1.113883.3.526.3.369'
valueset "Ejection Fraction": 'urn:oid:2.16.840.1.113883.3.526.3.1134'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Heart Rate": 'urn:oid:2.16.840.1.113883.3.526.3.1176'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hypotension": 'urn:oid:2.16.840.1.113883.3.526.3.370'
valueset "Intolerance to Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1178'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Moderate or Severe": 'urn:oid:2.16.840.1.113883.3.526.3.1092'
valueset "Moderate or Severe LVSD": 'urn:oid:2.16.840.1.113883.3.526.3.1090'
valueset "Myocardial Infarction": 'urn:oid:2.16.840.1.113883.3.526.3.403'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Patient Provider Interaction": 'urn:oid:2.16.840.1.113883.3.526.3.1012'
valueset "Patient Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "System Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1009'

code "Left ventricular systolic dysfunction (disorder)": '134401001' from "SNOMEDCT" display 'Left ventricular systolic dysfunction (disorder)'
code "Substance with beta adrenergic receptor antagonist mechanism of action (substance)": '373254001' from "SNOMEDCT" display 'Substance with beta adrenergic receptor antagonist mechanism of action (substance)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Coronary Artery Disease Encounter":
  "Outpatient Encounter During Measurement Period" ValidQualifyingEncounter
    with ["Diagnosis": "Coronary Artery Disease No MI"] CoronaryArteryDisease
      such that CoronaryArteryDisease.prevalencePeriod overlaps ValidQualifyingEncounter.relevantPeriod

define "Denominator 2":
  "Initial Population"
    and exists "Qualifying CAD Encounter and Prior MI"

define "Denominator Exceptions 2":
  "Has Arrhythmia with Qualifying CAD Encounter and Prior MI"
    or "Has Asthma with Qualifying CAD Encounter and Prior MI"
    or "Has Bradycardia with Qualifying CAD Encounter and Prior MI"
    or "Has Hypotension with Qualifying CAD Encounter and Prior MI"
    or "Has Consecutive Heart Rates Less than 50 with Qualifying CAD Encounter and Prior MI"
    or "Has Allergy or Intolerance to Beta Blocker Therapy Ingredient with Qualifying CAD Encounter and Prior MI"
    or "Has Diagnosis of Allergy or Intolerance to Beta Blocker Therapy with Qualifying CAD Encounter and Prior MI"
    or "Has Medical Patient or System Reason for Not Ordering Beta Blocker Therapy"
    or "Has Atrioventricular Block with Qualifying CAD Encounter and Prior MI without Cardiac Pacer"

define "Has Allergy or Intolerance to Beta Blocker Therapy Ingredient with Qualifying CAD Encounter and Prior MI":
  exists ( ["Allergy/Intolerance": "Beta Blocker Therapy Ingredient"]
    union ["Allergy/Intolerance": "Substance with beta adrenergic receptor antagonist mechanism of action (substance)"] ) BetaBlockerAllergyIntolerance
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that BetaBlockerAllergyIntolerance.prevalencePeriod overlaps after CADEncounterMI.relevantPeriod

define "Has Arrhythmia with Qualifying CAD Encounter and Prior MI":
  exists ["Diagnosis": "Arrhythmia"] Arrhythmia
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that Arrhythmia.prevalencePeriod overlaps CADEncounterMI.relevantPeriod

define "Has Asthma with Qualifying CAD Encounter and Prior MI":
  exists ["Diagnosis": "Asthma"] Asthma
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that Asthma.prevalencePeriod overlaps CADEncounterMI.relevantPeriod

define "Has Atrioventricular Block with Qualifying CAD Encounter and Prior MI":
  exists ["Diagnosis": "Atrioventricular Block"] AtrioventricularBlock
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that AtrioventricularBlock.prevalencePeriod overlaps CADEncounterMI.relevantPeriod

define "Has Atrioventricular Block with Qualifying CAD Encounter and Prior MI without Cardiac Pacer":
  "Has Atrioventricular Block with Qualifying CAD Encounter and Prior MI"
    and not "Has Diagnosis of Cardiac Pacer in Situ with Qualifying CAD Encounter and Prior MI"
    and not "Has Cardiac Pacer Device Implanted with Qualifying CAD Encounter and Prior MI"

define "Has Beta Blocker Therapy Ordered":
  exists ["Medication, Order": "Beta Blocker Therapy"] BetaBlockerOrdered
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that BetaBlockerOrdered.authorDatetime during CADEncounterMI.relevantPeriod

define "Has Bradycardia with Qualifying CAD Encounter and Prior MI":
  exists ["Diagnosis": "Bradycardia"] Bradycardia
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that Bradycardia.prevalencePeriod overlaps CADEncounterMI.relevantPeriod

define "Has Consecutive Heart Rates Less than 50 with Qualifying CAD Encounter and Prior MI":
  exists from
    ["Physical Exam, Performed": "Heart Rate"] HeartRate,
    "Qualifying CAD Encounter and Prior MI" CADEncounterMI
    let PriorHeartRate: Last(["Physical Exam, Performed": "Heart Rate"] MostRecentPriorHeartRate
        where Global."NormalizeInterval"(MostRecentPriorHeartRate.relevantDatetime, MostRecentPriorHeartRate.relevantPeriod)during CADEncounterMI.relevantPeriod
          and Global."NormalizeInterval"(MostRecentPriorHeartRate.relevantDatetime, MostRecentPriorHeartRate.relevantPeriod)before Global."NormalizeInterval"(HeartRate.relevantDatetime, HeartRate.relevantPeriod)
        sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
    )
    where Global."NormalizeInterval" ( HeartRate.relevantDatetime, HeartRate.relevantPeriod ) during CADEncounterMI.relevantPeriod
      and HeartRate.result < 50 '{beats}/min'
      and PriorHeartRate.result < 50 '{beats}/min'

define "Has Diagnosis of Allergy or Intolerance to Beta Blocker Therapy with Qualifying CAD Encounter and Prior MI":
  exists ( ["Diagnosis": "Allergy to Beta Blocker Therapy"]
    union ["Diagnosis": "Intolerance to Beta Blocker Therapy"] ) BetaBlockerAllergyOrIntoleranceDiagnosis
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that BetaBlockerAllergyOrIntoleranceDiagnosis.prevalencePeriod overlaps after CADEncounterMI.relevantPeriod

define "Has Hypotension with Qualifying CAD Encounter and Prior MI":
  exists ["Diagnosis": "Hypotension"] Hypotension
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that Hypotension.prevalencePeriod overlaps CADEncounterMI.relevantPeriod

define "Has Medical Patient or System Reason for Not Ordering Beta Blocker Therapy":
  exists ["Medication, Not Ordered": "Beta Blocker Therapy"] NoBetaBlockerOrdered
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that NoBetaBlockerOrdered.authorDatetime during CADEncounterMI.relevantPeriod
    where ( NoBetaBlockerOrdered.negationRationale in "Medical Reason"
        or NoBetaBlockerOrdered.negationRationale in "Patient Reason"
        or NoBetaBlockerOrdered.negationRationale in "System Reason"
    )

define "History of Cardiac Surgery":
  "Outpatient Encounter During Measurement Period" ValidQualifyingEncounter
    with ["Procedure, Performed": "Cardiac Surgery"] CardiacSurgery
      such that Global."NormalizeInterval" ( CardiacSurgery.relevantDatetime, CardiacSurgery.relevantPeriod ) starts before 
      end of ValidQualifyingEncounter.relevantPeriod

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")>= 18
    and Count("Qualifying Encounter During Measurement Period")>= 2
    and ( exists "Qualifying CAD Encounter" )

define "Is Currently Taking Beta Blocker Therapy":
  exists ["Medication, Active": "Beta Blocker Therapy"] ActiveBetaBlocker
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that ActiveBetaBlocker.relevantPeriod overlaps after CADEncounterMI.relevantPeriod

define "Moderate or Severe LVSD Findings":
  ( ["Diagnostic Study, Performed": "Ejection Fraction"] EjectionFraction
      where EjectionFraction.result <= 40 '%'
  )
    union ["Diagnosis": "Moderate or Severe LVSD"]
    union ( ["Diagnosis": "Left ventricular systolic dysfunction (disorder)"] LVSD
        where LVSD.severity in "Moderate or Severe"
    )

define "Numerator 1":
  "Has Beta Blocker Therapy for LVSD Ordered"
    or "Is Currently Taking Beta Blocker Therapy for LVSD"

define "Numerator 2":
  "Has Beta Blocker Therapy Ordered"
    or "Is Currently Taking Beta Blocker Therapy"

define "Outpatient Encounter During Measurement Period":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Care Services in Long-Term Residential Facility"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Nursing Facility Visit"] ) QualifyingEncounter
    where QualifyingEncounter.relevantPeriod during "Measurement Period"

define "Qualifying CAD Encounter":
  "Coronary Artery Disease Encounter"
    union "History of Cardiac Surgery"

define "Qualifying Encounter During Measurement Period":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Care Services in Long-Term Residential Facility"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Patient Provider Interaction"] ) ValidEncounter
    where ValidEncounter.relevantPeriod during "Measurement Period"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Has Cardiac Pacer Device Implanted with Qualifying CAD Encounter and Prior MI":
  exists ["Procedure, Performed": "Cardiac Pacer"] ImplantedCardiacPacer
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that ( Global."NormalizeInterval" ( ImplantedCardiacPacer.relevantDatetime, ImplantedCardiacPacer.relevantPeriod ) ) starts before 
      end of CADEncounterMI.relevantPeriod

define "Has Diagnosis of Cardiac Pacer in Situ with Qualifying CAD Encounter and Prior MI":
  exists ["Diagnosis": "Cardiac Pacer in Situ"] CardiacPacerDiagnosis
    with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
      such that CardiacPacerDiagnosis.prevalencePeriod overlaps after CADEncounterMI.relevantPeriod

define "Qualifying CAD Encounter and Prior MI":
  "Qualifying CAD Encounter" EncounterWithCADProxy
    with ["Diagnosis": "Myocardial Infarction"] MyocardialInfarction
      such that MyocardialInfarction.prevalencePeriod starts 3 years or less before day of start of EncounterWithCADProxy.relevantPeriod
        and not exists "Moderate or Severe LVSD Findings"

define "Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  "Qualifying CAD Encounter" EncounterWithCADProxy
    with "Moderate or Severe LVSD Findings" LVSDFindings
      such that Coalesce(LVSDFindings.prevalencePeriod, Global."NormalizeInterval"(LVSDFindings.relevantDatetime, LVSDFindings.relevantPeriod))starts before 
      end of EncounterWithCADProxy.relevantPeriod

define "Denominator 1":
  "Initial Population"
    and exists "Qualifying CAD Encounter and History of Moderate or Severe LVSD"

define "Has Allergy or Intolerance to Beta Blocker Therapy Ingredient with Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  exists ( ["Allergy/Intolerance": "Beta Blocker Therapy Ingredient"]
    union ["Allergy/Intolerance": "Substance with beta adrenergic receptor antagonist mechanism of action (substance)"] ) BetaBlockerAllergyIntolerance
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that BetaBlockerAllergyIntolerance.prevalencePeriod overlaps after CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Has Arrhythmia with Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  exists ["Diagnosis": "Arrhythmia"] Arrhythmia
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that Arrhythmia.prevalencePeriod overlaps CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Has Asthma with Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  exists ["Diagnosis": "Asthma"] Asthma
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that Asthma.prevalencePeriod overlaps CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Has Atrioventricular Block with Qualifying CAD Encounter and History of Moderate or Severe LVSD without Cardiac Pacer":
  "Has Atrioventricular Block with Qualifying CAD Encounter and History of Moderate or Severe LVSD"
    and not "Has Diagnosis of Cardiac Pacer in Situ with Qualifying CAD Encounter and History of Moderate or Severe LVSD"
    and not "Has Cardiac Pacer Device Implanted with Qualifying CAD Encounter and History of Moderate or Severe LVSD"

define "Has Beta Blocker Therapy for LVSD Ordered":
  exists ["Medication, Order": "Beta Blocker Therapy for LVSD"] BetaBlockerForLVSDOrdered
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that BetaBlockerForLVSDOrdered.authorDatetime during CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Has Consecutive Heart Rates Less than 50 with Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  exists from
    ["Physical Exam, Performed": "Heart Rate"] HeartRate,
    "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
    let PriorHeartRate: Last(["Physical Exam, Performed": "Heart Rate"] MostRecentPriorHeartRate
        where Global."NormalizeInterval"(MostRecentPriorHeartRate.relevantDatetime, MostRecentPriorHeartRate.relevantPeriod)during CADEncounterModerateOrSevereLVSD.relevantPeriod
          and Global."NormalizeInterval"(MostRecentPriorHeartRate.relevantDatetime, MostRecentPriorHeartRate.relevantPeriod)before Global."NormalizeInterval"(HeartRate.relevantDatetime, HeartRate.relevantPeriod)
        sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
    )
    where Global."NormalizeInterval" ( HeartRate.relevantDatetime, HeartRate.relevantPeriod ) during CADEncounterModerateOrSevereLVSD.relevantPeriod
      and HeartRate.result < 50 '{beats}/min'
      and PriorHeartRate.result < 50 '{beats}/min'

define "Has Cardiac Pacer Device Implanted with Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  exists ["Procedure, Performed": "Cardiac Pacer"] ImplantedCardiacPacer
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that ( Global."NormalizeInterval" ( ImplantedCardiacPacer.relevantDatetime, ImplantedCardiacPacer.relevantPeriod ) ) starts before 
      end of CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Has Bradycardia with Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  exists ["Diagnosis": "Bradycardia"] Bradycardia
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that Bradycardia.prevalencePeriod overlaps CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Has Diagnosis of Allergy or Intolerance to Beta Blocker Therapy with Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  exists ( ["Diagnosis": "Allergy to Beta Blocker Therapy"]
    union ["Diagnosis": "Intolerance to Beta Blocker Therapy"] ) BetaBlockerAllergyOrIntoleranceDiagnosis
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that BetaBlockerAllergyOrIntoleranceDiagnosis.prevalencePeriod overlaps after CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Has Diagnosis of Cardiac Pacer in Situ with Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  exists ["Diagnosis": "Cardiac Pacer in Situ"] CardiacPacerDiagnosis
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that CardiacPacerDiagnosis.prevalencePeriod overlaps after CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Has Hypotension with Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  exists ["Diagnosis": "Hypotension"] Hypotension
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that Hypotension.prevalencePeriod overlaps CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Has Medical Patient or System Reason for Not Ordering Beta Blocker for LVSD":
  exists ["Medication, Not Ordered": "Beta Blocker Therapy for LVSD"] NoBetaBlockerForLVSDOrdered
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that NoBetaBlockerForLVSDOrdered.authorDatetime during CADEncounterModerateOrSevereLVSD.relevantPeriod
    where ( NoBetaBlockerForLVSDOrdered.negationRationale in "Medical Reason"
        or NoBetaBlockerForLVSDOrdered.negationRationale in "Patient Reason"
        or NoBetaBlockerForLVSDOrdered.negationRationale in "System Reason"
    )

define "Is Currently Taking Beta Blocker Therapy for LVSD":
  exists ["Medication, Active": "Beta Blocker Therapy for LVSD"] ActiveBetaBlockerForLVSD
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that ActiveBetaBlockerForLVSD.relevantPeriod overlaps after CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Has Atrioventricular Block with Qualifying CAD Encounter and History of Moderate or Severe LVSD":
  exists ["Diagnosis": "Atrioventricular Block"] AtrioventricularBlock
    with "Qualifying CAD Encounter and History of Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
      such that AtrioventricularBlock.prevalencePeriod overlaps CADEncounterModerateOrSevereLVSD.relevantPeriod

define "Denominator Exceptions 1":
  "Has Arrhythmia with Qualifying CAD Encounter and History of Moderate or Severe LVSD"
    or "Has Asthma with Qualifying CAD Encounter and History of Moderate or Severe LVSD"
    or "Has Bradycardia with Qualifying CAD Encounter and History of Moderate or Severe LVSD"
    or "Has Hypotension with Qualifying CAD Encounter and History of Moderate or Severe LVSD"
    or "Has Consecutive Heart Rates Less than 50 with Qualifying CAD Encounter and History of Moderate or Severe LVSD"
    or "Has Allergy or Intolerance to Beta Blocker Therapy Ingredient with Qualifying CAD Encounter and History of Moderate or Severe LVSD"
    or "Has Diagnosis of Allergy or Intolerance to Beta Blocker Therapy with Qualifying CAD Encounter and History of Moderate or Severe LVSD"
    or "Has Medical Patient or System Reason for Not Ordering Beta Blocker for LVSD"
    or "Has Atrioventricular Block with Qualifying CAD Encounter and History of Moderate or Severe LVSD without Cardiac Pacer"