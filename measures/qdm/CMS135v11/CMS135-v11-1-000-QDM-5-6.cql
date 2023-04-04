library HFACEIorARBorARNIforLVSD version '11.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "RXNORM": 'urn:oid:2.16.840.1.113883.6.88'

valueset "ACE Inhibitor or ARB Ingredient": 'urn:oid:2.16.840.1.113883.3.526.3.1489'
valueset "ACE Inhibitor or ARB or ARNI": 'urn:oid:2.16.840.1.113883.3.526.3.1139'
valueset "Allergy to ACE Inhibitor or ARB": 'urn:oid:2.16.840.1.113883.3.526.3.1211'
valueset "Care Services in Long Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Ejection Fraction": 'urn:oid:2.16.840.1.113883.3.526.3.1134'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Heart Failure": 'urn:oid:2.16.840.1.113883.3.526.3.376'
valueset "Heart Transplant": 'urn:oid:2.16.840.1.113762.1.4.1178.33'
valueset "Heart Transplant Related Diagnoses": 'urn:oid:2.16.840.1.113762.1.4.1178.56'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Intolerance to ACE Inhibitor or ARB": 'urn:oid:2.16.840.1.113883.3.526.3.1212'
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
valueset "Patient Reason for ACE Inhibitor or ARB Decline": 'urn:oid:2.16.840.1.113883.3.526.3.1140'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pregnancy": 'urn:oid:2.16.840.1.113883.3.526.3.378'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Acute renal failure caused by angiotensin-converting-enzyme inhibitor (disorder)": '422593004' from "SNOMEDCT" display 'Acute renal failure caused by angiotensin-converting-enzyme inhibitor (disorder)'
code "Left ventricular systolic dysfunction (disorder)": '134401001' from "SNOMEDCT" display 'Left ventricular systolic dysfunction (disorder)'
code "sacubitril": '1656328' from "RXNORM" display 'sacubitril'
code "Substance with angiotensin II receptor antagonist mechanism of action (substance)": '372913009' from "SNOMEDCT" display 'Substance with angiotensin II receptor antagonist mechanism of action (substance)'
code "Substance with angiotensin-converting enzyme inhibitor mechanism of action (substance)": '372733002' from "SNOMEDCT" display 'Substance with angiotensin-converting enzyme inhibitor mechanism of action (substance)'
code "Substance with neprilysin inhibitor mechanism of action (substance)": '786886009' from "SNOMEDCT" display 'Substance with neprilysin inhibitor mechanism of action (substance)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator Exceptions":
  "Has Medical or Patient Reason for Not Ordering ACEI or ARB or ARNI"
    or "Has Allergy or Intolerance to ACEI or ARB or ARNI Ingredient"
    or "Has Diagnosis of Allergy or Intolerance to ACEI or ARB"
    or "Has Diagnosis of Pregnancy"
    or "Has Diagnosis of Renal Failure Due to ACEI"

define "Heart Failure Outpatient Encounter":
  ( ["Encounter, Performed": "Care Services in Long Term Residential Facility"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"] ) QualifyingEncounter
    with ["Diagnosis": "Heart Failure"] HeartFailure
      such that HeartFailure.prevalencePeriod overlaps QualifyingEncounter.relevantPeriod
    where QualifyingEncounter.relevantPeriod during "Measurement Period"

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")>= 18
    and Count("Qualifying Encounter During Measurement Period")>= 2
    and exists "Heart Failure Outpatient Encounter"

define "Numerator":
  "Has ACEI or ARB or ARNI Ordered"
    or "Is Currently Taking ACEI or ARB or ARNI"

define "Qualifying Encounter During Measurement Period":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Care Services in Long Term Residential Facility"]
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

define "Denominator Exclusions":
  "Has Heart Transplant"
    or "Has Heart Transplant Related Diagnosis"
    or "Has Left Ventricular Assist Device"
    or "Has Left Ventricular Assist Device Related Diagnosis"

define "Moderate or Severe LVSD Findings":
  ( ["Diagnostic Study, Performed": "Ejection Fraction"] EjectionFraction
      where EjectionFraction.result <= 40 '%'
  )
    union ["Diagnosis": "Moderate or Severe LVSD"]
    union ( ["Diagnosis": "Left ventricular systolic dysfunction (disorder)"] LVSD
        where LVSD.severity in "Moderate or Severe"
    )

define "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD":
  "Heart Failure Outpatient Encounter" HFOutpatientEncounter
    with "Moderate or Severe LVSD Findings" LVSDFindings
      such that Coalesce(LVSDFindings.prevalencePeriod, Global."NormalizeInterval"(LVSDFindings.relevantDatetime, LVSDFindings.relevantPeriod))starts before 
      end of HFOutpatientEncounter.relevantPeriod

define "Denominator":
  "Initial Population"
    and exists "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD"

define "Has ACEI or ARB or ARNI Ordered":
  exists ["Medication, Order": "ACE Inhibitor or ARB or ARNI"] ACEIOrARBOrARNIOrdered
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ACEIOrARBOrARNIOrdered.authorDatetime during ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Allergy or Intolerance to ACEI or ARB or ARNI Ingredient":
  exists ( ["Allergy/Intolerance": "ACE Inhibitor or ARB Ingredient"]
    union ["Allergy/Intolerance": "Substance with angiotensin-converting enzyme inhibitor mechanism of action (substance)"]
    union ["Allergy/Intolerance": "Substance with angiotensin II receptor antagonist mechanism of action (substance)"]
    union ["Allergy/Intolerance": "Substance with neprilysin inhibitor mechanism of action (substance)"]
    union ["Allergy/Intolerance": "sacubitril"] ) ACEIOrARBOrARNIAllergyIntolerance
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ACEIOrARBOrARNIAllergyIntolerance.prevalencePeriod overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Diagnosis of Allergy or Intolerance to ACEI or ARB":
  exists ( ["Diagnosis": "Allergy to ACE Inhibitor or ARB"]
    union ["Diagnosis": "Intolerance to ACE Inhibitor or ARB"] ) ACEIOrARBAllergyOrIntoleranceDiagnosis
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ACEIOrARBAllergyOrIntoleranceDiagnosis.prevalencePeriod overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Diagnosis of Pregnancy":
  exists ["Diagnosis": "Pregnancy"] Pregnancy
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Pregnancy.prevalencePeriod starts 9 months or less before or on start ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Diagnosis of Renal Failure Due to ACEI":
  exists ["Diagnosis": "Acute renal failure caused by angiotensin-converting-enzyme inhibitor (disorder)"] RenalFailureDueToACEI
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that RenalFailureDueToACEI.prevalencePeriod overlaps ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

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

define "Has Left Ventricular Assist Device":
  exists ["Procedure, Performed": "Left Ventricular Assist Device Placement"] LVADOutpatient
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( LVADOutpatient.relevantDatetime, LVADOutpatient.relevantPeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Left Ventricular Assist Device Related Diagnosis":
  exists ["Diagnosis": "Left Ventricular Assist Device Related Diagnoses"] LVADCondition
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ( Global."NormalizeInterval" ( LVADCondition.authorDatetime, LVADCondition.prevalencePeriod ) ) starts before 
      end of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Medical or Patient Reason for Not Ordering ACEI or ARB or ARNI":
  exists ["Medication, Not Ordered": "ACE Inhibitor or ARB or ARNI"] NoACEIOrARBOrARNIOrdered
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that NoACEIOrARBOrARNIOrdered.authorDatetime during ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod
    where ( NoACEIOrARBOrARNIOrdered.negationRationale in "Medical Reason"
        or NoACEIOrARBOrARNIOrdered.negationRationale in "Patient Reason"
        or NoACEIOrARBOrARNIOrdered.negationRationale in "Patient Reason for ACE Inhibitor or ARB Decline"
    )

define "Is Currently Taking ACEI or ARB or ARNI":
  exists ["Medication, Active": "ACE Inhibitor or ARB or ARNI"] ActiveACEIOrARBOrARNI
    with "Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ActiveACEIOrARBOrARNI.relevantPeriod overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod