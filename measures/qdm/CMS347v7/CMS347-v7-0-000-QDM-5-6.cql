library StatinTherapyforthePreventionandTreatmentofCardiovascularDisease version '7.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '5.0.000' called Hospice
include PalliativeCareExclusionECQM version '3.0.000' called PalliativeCare

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Atherosclerosis and Peripheral Arterial Disease": 'urn:oid:2.16.840.1.113762.1.4.1047.21'
valueset "Breastfeeding": 'urn:oid:2.16.840.1.113762.1.4.1047.73'
valueset "CABG or PCI Procedure": 'urn:oid:2.16.840.1.113762.1.4.1138.566'
valueset "CABG Surgeries": 'urn:oid:2.16.840.1.113883.3.666.5.694'
valueset "Carotid Intervention": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.204'
valueset "Cerebrovascular Disease Stroke or TIA": 'urn:oid:2.16.840.1.113762.1.4.1047.44'
valueset "Diabetes": 'urn:oid:2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "End Stage Renal Disease": 'urn:oid:2.16.840.1.113883.3.526.3.353'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Familial Hypercholesterolemia": 'urn:oid:2.16.840.1.113762.1.4.1047.100'
valueset "Hepatitis A": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1024'
valueset "Hepatitis B": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.269'
valueset "High Intensity Statin Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1572'
valueset "Ischemic Heart Disease or Related Diagnoses": 'urn:oid:2.16.840.1.113762.1.4.1047.46'
valueset "LDL Cholesterol": 'urn:oid:2.16.840.1.113883.3.526.3.1573'
valueset "Liver Disease": 'urn:oid:2.16.840.1.113762.1.4.1047.42'
valueset "Low Intensity Statin Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1574'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Moderate Intensity Statin Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1575'
valueset "Myocardial Infarction": 'urn:oid:2.16.840.1.113762.1.4.1108.101'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Outpatient Encounters for Preventive Care": 'urn:oid:2.16.840.1.113883.3.526.3.1576'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "PCI": 'urn:oid:2.16.840.1.113762.1.4.1045.67'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Rhabdomyolysis": 'urn:oid:2.16.840.1.113762.1.4.1047.102'
valueset "Stable and Unstable Angina": 'urn:oid:2.16.840.1.113762.1.4.1047.47'
valueset "Statin Allergen": 'urn:oid:2.16.840.1.113762.1.4.1110.42'
valueset "Statin Associated Muscle Symptoms": 'urn:oid:2.16.840.1.113762.1.4.1108.85'

code "Cardiovascular disease 10Y risk [Likelihood]": '99055-6' from "LOINC" display 'Cardiovascular disease 10Y risk [Likelihood]'
code "Cardiovascular disease 10Y risk [Likelihood] ACC-AHA Pooled Cohort by Goff 2013": '79423-0' from "LOINC" display 'Cardiovascular disease 10Y risk [Likelihood] ACC-AHA Pooled Cohort by Goff 2013'
code "Unlisted preventive medicine service": '99429' from "CPT" display 'Unlisted preventive medicine service'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator 1":
  "Initial Population 1"

define "Denominator 2":
  "Initial Population 2"

define "Denominator 3":
  "Initial Population 3"

define "Denominator 4":
  "Initial Population 4"

define "Denominator Exceptions":
  "Has Allergy to Statin"
    or Hospice."Has Hospice Services"
    or PalliativeCare."Has Palliative Care in the Measurement Period"
    or "Has Hepatitis or Liver Disease Diagnosis"
    or "Has Statin Associated Muscle Symptoms"
    or "Has ESRD Diagnosis"
    or "Has Adverse Reaction to Statin"
    or "Has Medical Reason for Not Ordering Statin Therapy"

define "Denominator Exclusions":
  exists ( ( ["Diagnosis": "Breastfeeding"]
      union ["Diagnosis": "Rhabdomyolysis"] ) ExclusionDiagnosis
      where ExclusionDiagnosis.prevalencePeriod overlaps day of "Measurement Period"
  )

define "Has Adverse Reaction to Statin":
  exists ["Adverse Event": "Statin Allergen"] StatinReaction
    where StatinReaction.relevantDatetime during day of "Measurement Period"

define "Has Allergy to Statin":
  exists ["Allergy/Intolerance": "Statin Allergen"] StatinAllergy
    where StatinAllergy.prevalencePeriod overlaps day of "Measurement Period"

define "Has Diabetes Diagnosis":
  exists ( ["Diagnosis": "Diabetes"] Diabetes
      where Diabetes.prevalencePeriod overlaps day of "Measurement Period"
  )

define "Has ESRD Diagnosis":
  exists ( ["Diagnosis": "End Stage Renal Disease"] ESRD
      where ESRD.prevalencePeriod overlaps day of "Measurement Period"
  )

define "Has Hepatitis or Liver Disease Diagnosis":
  exists ( ( ["Diagnosis": "Hepatitis A"]
      union ["Diagnosis": "Hepatitis B"]
      union ["Diagnosis": "Liver Disease"] ) HepatitisLiverDisease
      where HepatitisLiverDisease.prevalencePeriod overlaps day of "Measurement Period"
  )

define "Has Medical Reason for Not Ordering Statin Therapy":
  exists ( ( ["Medication, Not Ordered": "Low Intensity Statin Therapy"]
      union ["Medication, Not Ordered": "Moderate Intensity Statin Therapy"]
      union ["Medication, Not Ordered": "High Intensity Statin Therapy"] ) NoStatinTherapyOrdered
      with "Qualifying Encounter during Day of Measurement Period" QualifyingEncounter
        such that NoStatinTherapyOrdered.authorDatetime during QualifyingEncounter.relevantPeriod
      where NoStatinTherapyOrdered.negationRationale in "Medical Reason"
  )

define "Has Statin Associated Muscle Symptoms":
  exists ( ["Diagnosis": "Statin Associated Muscle Symptoms"] StatinMuscleSymptom
      where StatinMuscleSymptom.prevalencePeriod overlaps day of "Measurement Period"
  )

define "Hypercholesterolemia Diagnosis":
  ( ["Diagnosis": "Familial Hypercholesterolemia"] Hypercholesterolemia
      where Hypercholesterolemia.prevalencePeriod starts before 
      end of "Measurement Period"
  )

define "Initial Population 1":
  exists "ASCVD Diagnosis or Procedure before End of Measurement Period"
    and exists "Qualifying Encounter during Day of Measurement Period"

define "Initial Population 2":
  "Patients Age 20 to 75 with LDL Cholesterol Result Greater than or Equal to 190 or Hypercholesterolemia without ASCVD"
    and exists "Qualifying Encounter during Day of Measurement Period"

define "Initial Population 3":
  "Patients Age 40 to 75 Years with Diabetes without ASCVD or LDL Greater than 190 or Hypercholesterolemia"
    and exists "Qualifying Encounter during Day of Measurement Period"

define "Initial Population 4":
  "Patients Age 40 to 75 Years and have a 10 Year CVD Risk of High without ASCVD and High LDL and Diabetes"
    and exists "Qualifying Encounter during Day of Measurement Period"

define "LDL Result Greater Than or Equal To 190":
  ["Laboratory Test, Performed": "LDL Cholesterol"] LDL190
    where LDL190.result >= 190 'mg/dL'
      and Global."NormalizeInterval" ( LDL190.relevantDatetime, LDL190.relevantPeriod ) starts before 
      end of "Measurement Period"

define "Numerator":
  exists "Statin Therapy Ordered during Measurement Period"
    or exists "Prescribed Statin Therapy Any Time during Measurement Period"

define "Patients Age 20 to 75 with LDL Cholesterol Result Greater than or Equal to 190 or Hypercholesterolemia without ASCVD":
  "Patients Aged 20 to 75 at Start of Measurement Period"
    and exists ( "LDL Result Greater Than or Equal To 190"
        union "Hypercholesterolemia Diagnosis"
    )
    and not exists "ASCVD Diagnosis or Procedure before End of Measurement Period"

define "Patients Age 40 to 75 Years with Diabetes without ASCVD or LDL Greater than 190 or Hypercholesterolemia":
  AgeInYearsAt(date from start of "Measurement Period")in Interval[40, 75]
    and "Has Diabetes Diagnosis"
    and ( not exists "ASCVD Diagnosis or Procedure before End of Measurement Period"
        and not exists "LDL Result Greater Than or Equal To 190"
        and not exists "Hypercholesterolemia Diagnosis"
    )

define "Patients Aged 20 to 75 at Start of Measurement Period":
  AgeInYearsAt(date from start of "Measurement Period")in Interval[20, 75]

define "Prescribed Statin Therapy Any Time during Measurement Period":
  ( ["Medication, Active": "Low Intensity Statin Therapy"]
    union ["Medication, Active": "Moderate Intensity Statin Therapy"]
    union ["Medication, Active": "High Intensity Statin Therapy"] ) ActiveStatin
    where Global."NormalizeInterval" ( ActiveStatin.relevantDatetime, ActiveStatin.relevantPeriod ) overlaps day of "Measurement Period"

define "Qualifying Encounter during Day of Measurement Period":
  ( ["Encounter, Performed": "Annual Wellness Visit"]
    union ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Outpatient Encounters for Preventive Care"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Unlisted preventive medicine service"]
    union ["Encounter, Performed": "Preventive Care Services Individual Counseling"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"] ) ValidEncounter
    where ValidEncounter.relevantPeriod during day of "Measurement Period"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Statin Therapy Ordered during Measurement Period":
  ( ["Medication, Order": "Low Intensity Statin Therapy"]
    union ["Medication, Order": "Moderate Intensity Statin Therapy"]
    union ["Medication, Order": "High Intensity Statin Therapy"] ) StatinOrdered
    where StatinOrdered.authorDatetime during day of "Measurement Period"

define "Ten Year CVD Risk is High":
  ( exists ( ["Assessment, Performed": "Cardiovascular disease 10Y risk [Likelihood]"]
      union ["Assessment, Performed": "Cardiovascular disease 10Y risk [Likelihood] ACC-AHA Pooled Cohort by Goff 2013"] ) AtRiskCVD
      where AtRiskCVD.result as Quantity >= 20 '%'
        and Global."NormalizeInterval" ( AtRiskCVD.relevantDatetime, AtRiskCVD.relevantPeriod ) during "Measurement Period"
  )

define "Patients Age 40 to 75 Years and have a 10 Year CVD Risk of High without ASCVD and High LDL and Diabetes":
  AgeInYearsAt(date from start of "Measurement Period")in Interval[40, 75]
    and "Ten Year CVD Risk is High"
    and not ( exists "ASCVD Diagnosis or Procedure before End of Measurement Period"
        or exists "Hypercholesterolemia Diagnosis"
        or exists "LDL Result Greater Than or Equal To 190"
        or "Has Diabetes Diagnosis"
    )

define "ASCVD Diagnosis or Procedure before End of Measurement Period":
  ( ( ["Diagnosis": "Myocardial Infarction"]
      union ["Diagnosis": "Cerebrovascular Disease Stroke or TIA"]
      union ["Diagnosis": "Atherosclerosis and Peripheral Arterial Disease"]
      union ["Diagnosis": "Ischemic Heart Disease or Related Diagnoses"]
      union ["Diagnosis": "Stable and Unstable Angina"] ) ASCVDDiagnosis
      where ASCVDDiagnosis.prevalencePeriod starts before 
      end of "Measurement Period"
  )
    union ( ( ["Procedure, Performed": "PCI"]
        union ["Procedure, Performed": "CABG Surgeries"]
        union ["Procedure, Performed": "Carotid Intervention"]
        union ["Procedure, Performed": "CABG or PCI Procedure"] ) ASCVDProcedure
        where Global."NormalizeInterval" ( ASCVDProcedure.relevantDatetime, ASCVDProcedure.relevantPeriod ) starts before 
        end of "Measurement Period"
    )