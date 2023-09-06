library PCSBMIScreenAndFollowUp version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '5.0.000' called Hospice
include PalliativeCareExclusionECQM version '3.0.000' called PalliativeCare

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "ActCode": 'urn:oid:2.16.840.1.113883.5.4'

valueset "Encounter to Evaluate BMI": 'urn:oid:2.16.840.1.113883.3.600.1.1751'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Follow Up for Above Normal BMI": 'urn:oid:2.16.840.1.113883.3.600.1.1525'
valueset "Follow Up for Below Normal BMI": 'urn:oid:2.16.840.1.113883.3.600.1.1528'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Medications for Above Normal BMI": 'urn:oid:2.16.840.1.113883.3.526.3.1561'
valueset "Medications for Below Normal BMI": 'urn:oid:2.16.840.1.113883.3.526.3.1562'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Overweight or Obese": 'urn:oid:2.16.840.1.113762.1.4.1047.502'
valueset "Patient Declined": 'urn:oid:2.16.840.1.113883.3.526.3.1582'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pregnancy Obstetric or Maternal Diagnoses": 'urn:oid:2.16.840.1.113883.3.600.1.1623'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Referrals Where Weight Assessment May Occur": 'urn:oid:2.16.840.1.113883.3.600.1.1527'
valueset "Underweight": 'urn:oid:2.16.840.1.113883.3.526.3.1563'

code "Body mass index (BMI) [Ratio]": '39156-5' from "LOINC" display 'Body mass index (BMI) [Ratio]'
code "virtual": 'VR' from "ActCode" display 'virtual'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Denominator Exceptions":
  exists "Medical Reason for Not Documenting a Follow up Plan for Low or High BMI"
    or exists "Medical Reason or Patient Reason for Not Performing BMI Exam"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or PalliativeCare."Has Palliative Care in the Measurement Period"
    or exists "Pregnancy"

define "High BMI and Follow up Provided":
  ( "Documented High BMI during Measurement Period" HighBMI
      with ( "High BMI Interventions Ordered"
        union "High BMI Interventions Performed" ) HighBMIInterventions
        such that ( Coalesce(start of Global."NormalizeInterval"(HighBMIInterventions.relevantDatetime, HighBMIInterventions.relevantPeriod), HighBMIInterventions.authorDatetime)during day of "Measurement Period" )
  )

define "Initial Population":
  exists "Qualifying Encounter during Day of Measurement Period" QualifyingEncounter
    where "AgeInYearsAt"(date from start of QualifyingEncounter.relevantPeriod)>= 18

define "Low BMI and Follow up Provided":
  ( "Documented Low BMI during Measurement Period" LowBMI
      with ( "Low BMI Interventions Ordered"
        union "Low BMI Interventions Performed" ) LowBMIInterventions
        such that ( Coalesce(start of Global."NormalizeInterval"(LowBMIInterventions.relevantDatetime, LowBMIInterventions.relevantPeriod), LowBMIInterventions.authorDatetime)during day of "Measurement Period" )
  )

define "Medical Reason for Not Documenting a Follow up Plan for Low or High BMI":
  ( ["Intervention, Not Ordered": "Referrals Where Weight Assessment May Occur"]
    union ["Intervention, Not Ordered": "Follow Up for Above Normal BMI"]
    union ["Intervention, Not Performed": "Follow Up for Above Normal BMI"]
    union ["Intervention, Not Ordered": "Follow Up for Below Normal BMI"]
    union ["Intervention, Not Performed": "Follow Up for Below Normal BMI"]
    union ["Medication, Not Ordered": "Medications for Above Normal BMI"]
    union ["Medication, Not Ordered": "Medications for Below Normal BMI"] ) NoBMIFollowUp
    with "Qualifying Encounter during Day of Measurement Period" QualifyingEncounter
      such that NoBMIFollowUp.authorDatetime same day as start of QualifyingEncounter.relevantPeriod
    where NoBMIFollowUp.negationRationale in "Medical Reason"

define "Medical Reason or Patient Reason for Not Performing BMI Exam":
  ["Physical Exam, Not Performed": "Body mass index (BMI) [Ratio]"] NoBMI
    with "Qualifying Encounter during Day of Measurement Period" QualifyingEncounter
      such that Global."NormalizeInterval" ( NoBMI.authorDatetime, NoBMI.relevantPeriod ) ends same day as start of QualifyingEncounter.relevantPeriod
    where ( NoBMI.negationRationale in "Medical Reason"
        or NoBMI.negationRationale in "Patient Declined"
    )

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Documented High BMI during Measurement Period":
  "BMI during Measurement Period" BMI
    where Global."NormalizeInterval" ( BMI.relevantDatetime, BMI.relevantPeriod ) during day of "Measurement Period"
      and BMI.result >= 25 'kg/m2'

define "Has Normal BMI":
  exists ( "BMI during Measurement Period" BMI
      where BMI.result included in Interval[18.5 'kg/m2', 24.9 'kg/m2']
  )
    and not ( exists "Documented High BMI during Measurement Period"
        or exists "Documented Low BMI during Measurement Period"
    )

define "Low BMI Interventions Ordered":
  ( ( ["Intervention, Order": "Follow Up for Below Normal BMI"]
      union ["Intervention, Order": "Referrals Where Weight Assessment May Occur"]
      union ["Medication, Order": "Medications for Below Normal BMI"] ) LowInterventionsOrdered
      where LowInterventionsOrdered.reason in "Underweight"
        or ( exists ["Diagnosis": "Underweight"] Underweight
            where Underweight.prevalencePeriod starts before or on day of LowInterventionsOrdered.authorDatetime
              and not ( Underweight.prevalencePeriod ends before day of LowInterventionsOrdered.authorDatetime )
        )
  )

define "Numerator":
  exists "High BMI and Follow up Provided"
    or exists "Low BMI and Follow up Provided"
    or "Has Normal BMI"

define "Pregnancy":
  ["Diagnosis": "Pregnancy Obstetric or Maternal Diagnoses"] PregnancyDiagnosis
    with "Qualifying Encounter during Day of Measurement Period" QualifyingEncounter
      such that PregnancyDiagnosis.prevalencePeriod overlaps day of "Measurement Period"

define "High BMI Interventions Ordered":
  ( ( ["Intervention, Order": "Follow Up for Above Normal BMI"]
      union ["Intervention, Order": "Referrals Where Weight Assessment May Occur"]
      union ["Medication, Order": "Medications for Above Normal BMI"] ) HighInterventionsOrdered
      where HighInterventionsOrdered.reason in "Overweight or Obese"
        or ( exists ["Diagnosis": "Overweight or Obese"] OverweightObese
            where OverweightObese.prevalencePeriod starts before or on day of HighInterventionsOrdered.authorDatetime
              and not ( OverweightObese.prevalencePeriod ends before day of HighInterventionsOrdered.authorDatetime )
        )
  )

define "Low BMI Interventions Performed":
  ( ["Intervention, Performed": "Follow Up for Below Normal BMI"] LowInterventionsPerformed
      where LowInterventionsPerformed.reason in "Underweight"
        or ( exists ["Diagnosis": "Underweight"] Underweight
            where Underweight.prevalencePeriod overlaps before Global."NormalizeInterval" ( LowInterventionsPerformed.relevantDatetime, LowInterventionsPerformed.relevantPeriod )
        )
  )

define "High BMI Interventions Performed":
  ( ["Intervention, Performed": "Follow Up for Above Normal BMI"] HighInterventionsPerformed
      where HighInterventionsPerformed.reason in "Overweight or Obese"
        or ( exists ["Diagnosis": "Overweight or Obese"] OverweightObese
            where OverweightObese.prevalencePeriod overlaps before Global."NormalizeInterval" ( HighInterventionsPerformed.relevantDatetime, HighInterventionsPerformed.relevantPeriod )
        )
  )

define "Qualifying Encounter during Day of Measurement Period":
  ["Encounter, Performed": "Encounter to Evaluate BMI"] BMIEncounter
    where BMIEncounter.relevantPeriod during day of "Measurement Period"
      and BMIEncounter.class !~ "virtual"

define "Documented Low BMI during Measurement Period":
  "BMI during Measurement Period" BMI
    where Global."NormalizeInterval" ( BMI.relevantDatetime, BMI.relevantPeriod ) during day of "Measurement Period"
      and BMI.result < 18.5 'kg/m2'

define "BMI during Measurement Period":
  ( ["Physical Exam, Performed": "Body mass index (BMI) [Ratio]"] BMI
      where Global."NormalizeInterval" ( BMI.relevantDatetime, BMI.relevantPeriod ) during day of "Measurement Period"
        and BMI.result > 0 'kg/m2'
  )