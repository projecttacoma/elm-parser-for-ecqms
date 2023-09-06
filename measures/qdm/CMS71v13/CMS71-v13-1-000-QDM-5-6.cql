library AnticoagulationTherapyforAtrialFibrillationFlutter version '13.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include TJCOverall version '7.1.000' called TJC

valueset "Anticoagulant Therapy": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.200'
valueset "Atrial Ablation": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.203'
valueset "Atrial Fibrillation or Flutter": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.202'
valueset "Discharge To Acute Care Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'
valueset "Discharged to Health Care Facility for Hospice Care": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.207'
valueset "Discharged to Home for Hospice Care": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.209'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "History of Atrial Ablation": 'urn:oid:2.16.840.1.113762.1.4.1110.76'
valueset "Left Against Medical Advice": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.308'
valueset "Medical Reason For Not Providing Treatment": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

context Patient

define "Denominator":
  "Encounter with a History of Atrial Ablation"
    union "Encounter with Prior or Present Diagnosis of Atrial Fibrillation or Flutter"

define "Denominator Exceptions":
  "Denominator" Encounter
    with "Documented Reason for Not Giving Anticoagulant at Discharge" NoDischargeAnticoagulant
      such that NoDischargeAnticoagulant.authorDatetime during Encounter.relevantPeriod

define "Denominator Exclusions":
  ( "Denominator" Encounter
      where Encounter.dischargeDisposition in "Discharge To Acute Care Facility"
        or Encounter.dischargeDisposition in "Left Against Medical Advice"
        or Encounter.dischargeDisposition in "Patient Expired"
        or Encounter.dischargeDisposition in "Discharged to Home for Hospice Care"
        or Encounter.dischargeDisposition in "Discharged to Health Care Facility for Hospice Care"
  )
    union "Encounter with Comfort Measures during Hospitalization for Patients with Documented Atrial Fibrillation or Flutter"

define "Encounter with Comfort Measures during Hospitalization for Patients with Documented Atrial Fibrillation or Flutter":
  "Denominator" Encounter
    with TJC."Intervention Comfort Measures" ComfortMeasure
      such that Coalesce(start of Global."NormalizeInterval"(ComfortMeasure.relevantDatetime, ComfortMeasure.relevantPeriod), ComfortMeasure.authorDatetime)during Global."HospitalizationWithObservation" ( Encounter )

define "Encounter with Prior or Present Diagnosis of Atrial Fibrillation or Flutter":
  ( TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
      with ["Diagnosis": "Atrial Fibrillation or Flutter"] AtrialFibrillationFlutter
        such that AtrialFibrillationFlutter.prevalencePeriod starts on or before 
        end of IschemicStrokeEncounter.relevantPeriod
  )
    union ( TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
        where exists ( IschemicStrokeEncounter.diagnoses Diagnosis
            where Diagnosis.code in "Atrial Fibrillation or Flutter"
        )
    )

define "Initial Population":
  TJC."Encounter with Principal Diagnosis and Age"

define "Numerator":
  "Denominator" Encounter
    with ["Medication, Discharge": "Anticoagulant Therapy"] DischargeAnticoagulant
      such that DischargeAnticoagulant.authorDatetime during Encounter.relevantPeriod

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Encounter with a History of Atrial Ablation":
  ( TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
      with ["Procedure, Performed": "Atrial Ablation"] AtrialAblationProcedure
        such that Global."NormalizeInterval" ( AtrialAblationProcedure.relevantDatetime, AtrialAblationProcedure.relevantPeriod ) starts before start of IschemicStrokeEncounter.relevantPeriod
  )
    union ( TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
        with ["Diagnosis": "History of Atrial Ablation"] AtrialAblationDiagnosis
          such that AtrialAblationDiagnosis.prevalencePeriod starts before start of IschemicStrokeEncounter.relevantPeriod
    )
    union ( TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
        with ["Assessment, Performed": "History of Atrial Ablation"] AtrialAblationAssessment
          such that Global."EarliestOf" ( AtrialAblationAssessment.relevantDatetime, AtrialAblationAssessment.relevantPeriod ) on or before 
          end of IschemicStrokeEncounter.relevantPeriod
    )

define "Documented Reason for Not Giving Anticoagulant at Discharge":
  ["Medication, Not Discharged": "Anticoagulant Therapy"] NoAnticoagulant
    where NoAnticoagulant.negationRationale in "Medical Reason For Not Providing Treatment"
      or NoAnticoagulant.negationRationale in "Patient Refusal"