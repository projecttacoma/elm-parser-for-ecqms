library HFACEIorARBorARNIforLVSD version '12.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include HFCommonDefinitions version '2.0.000' called HeartFailure

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "ACE Inhibitor or ARB or ARNI": 'urn:oid:2.16.840.1.113883.3.526.3.1139'
valueset "ACE Inhibitor or ARB or ARNI Ingredient": 'urn:oid:2.16.840.1.113883.3.526.3.1489'
valueset "Allergy to ACE Inhibitor or ARB": 'urn:oid:2.16.840.1.113883.3.526.3.1211'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Intolerance to ACE Inhibitor or ARB": 'urn:oid:2.16.840.1.113883.3.526.3.1212'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1008'
valueset "Patient Reason for ACE Inhibitor or ARB Decline": 'urn:oid:2.16.840.1.113883.3.526.3.1140'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pregnancy": 'urn:oid:2.16.840.1.113883.3.526.3.378'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Acute renal failure caused by angiotensin-converting-enzyme inhibitor (disorder)": '422593004' from "SNOMEDCT" display 'Acute renal failure caused by angiotensin-converting-enzyme inhibitor (disorder)'
code "Substance with angiotensin II receptor antagonist mechanism of action (substance)": '372913009' from "SNOMEDCT" display 'Substance with angiotensin II receptor antagonist mechanism of action (substance)'
code "Substance with angiotensin-converting enzyme inhibitor mechanism of action (substance)": '372733002' from "SNOMEDCT" display 'Substance with angiotensin-converting enzyme inhibitor mechanism of action (substance)'
code "Substance with neprilysin inhibitor mechanism of action (substance)": '786886009' from "SNOMEDCT" display 'Substance with neprilysin inhibitor mechanism of action (substance)'

context Patient

define "Denominator Exceptions":
  "Has Medical or Patient Reason for Not Ordering ACEI or ARB or ARNI"
    or "Has Allergy or Intolerance to ACEI or ARB or ARNI Ingredient"
    or "Has Diagnosis of Allergy or Intolerance to ACEI or ARB"
    or "Has Diagnosis of Pregnancy"
    or "Has Diagnosis of Renal Failure Due to ACEI"

define "Numerator":
  "Has ACEI or ARB or ARNI Ordered"
    or "Is Currently Taking ACEI or ARB or ARNI"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Initial Population":
  HeartFailure."Has Two Qualifying Outpatient Encounters and Heart Failure Outpatient Encounter During the Measurement Period"

define "Denominator":
  "Initial Population"
    and exists HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD"

define "Has ACEI or ARB or ARNI Ordered":
  exists ["Medication, Order": "ACE Inhibitor or ARB or ARNI"] ACEIOrARBOrARNIOrdered
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ACEIOrARBOrARNIOrdered.authorDatetime during day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Allergy or Intolerance to ACEI or ARB or ARNI Ingredient":
  exists ( ["Allergy/Intolerance": "ACE Inhibitor or ARB or ARNI Ingredient"]
    union ["Allergy/Intolerance": "Substance with angiotensin-converting enzyme inhibitor mechanism of action (substance)"]
    union ["Allergy/Intolerance": "Substance with angiotensin II receptor antagonist mechanism of action (substance)"]
    union ["Allergy/Intolerance": "Substance with neprilysin inhibitor mechanism of action (substance)"] ) ACEIOrARBOrARNIAllergyIntolerance
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ACEIOrARBOrARNIAllergyIntolerance.prevalencePeriod overlaps after day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Diagnosis of Allergy or Intolerance to ACEI or ARB":
  exists ( ["Diagnosis": "Allergy to ACE Inhibitor or ARB"]
    union ["Diagnosis": "Intolerance to ACE Inhibitor or ARB"] ) ACEIOrARBAllergyOrIntoleranceDiagnosis
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ACEIOrARBAllergyOrIntoleranceDiagnosis.prevalencePeriod overlaps after day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Diagnosis of Pregnancy":
  exists ["Diagnosis": "Pregnancy"] Pregnancy
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Pregnancy.prevalencePeriod starts 9 months or less before or on start ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Has Diagnosis of Renal Failure Due to ACEI":
  exists ["Diagnosis": "Acute renal failure caused by angiotensin-converting-enzyme inhibitor (disorder)"] RenalFailureDueToACEI
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that RenalFailureDueToACEI.prevalencePeriod overlaps day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Is Currently Taking ACEI or ARB or ARNI":
  exists ["Medication, Active": "ACE Inhibitor or ARB or ARNI"] ActiveACEIOrARBOrARNI
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that ActiveACEIOrARBOrARNI.relevantPeriod overlaps after day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Denominator Exclusions":
  HeartFailure."Has Heart Transplant"
    or HeartFailure."Has Heart Transplant Complications"
    or HeartFailure."Has Left Ventricular Assist Device"
    or HeartFailure."Has Left Ventricular Assist Device Complications"

define "Has Medical or Patient Reason for Not Ordering ACEI or ARB or ARNI":
  exists ["Medication, Not Ordered": "ACE Inhibitor or ARB or ARNI"] NoACEIOrARBOrARNIOrdered
    with HeartFailure."Heart Failure Outpatient Encounter with History of Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that NoACEIOrARBOrARNIOrdered.authorDatetime during day of ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod
    where ( NoACEIOrARBOrARNIOrdered.negationRationale in "Medical Reason"
        or NoACEIOrARBOrARNIOrdered.negationRationale in "Patient Reason"
        or NoACEIOrARBOrARNIOrdered.negationRationale in "Patient Reason for ACE Inhibitor or ARB Decline"
    )