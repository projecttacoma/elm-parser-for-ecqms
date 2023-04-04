library AntithromboticTherapyByEndofHospitalDay2 version '11.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include TJCOverall version '6.0.000' called TJC

valueset "Antithrombotic Therapy": 'urn:oid:2.16.840.1.113762.1.4.1110.62'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "INR": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.213'
valueset "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival": 'urn:oid:2.16.840.1.113762.1.4.1110.21'
valueset "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy": 'urn:oid:2.16.840.1.113762.1.4.1045.21'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pharmacological Contraindications For Antithrombotic Therapy": 'urn:oid:2.16.840.1.113762.1.4.1110.52'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Thrombolytic (t-PA) Therapy": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.226'

context Patient

define "Initial Population":
  TJC."Encounter with Principal Diagnosis and Age"

define "Numerator":
  "Encounter with Antithrombotic Therapy"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Thrombolytic Therapy Medication or Procedures":
  ["Medication, Administered": "Thrombolytic (t-PA) Therapy"]
    union ["Procedure, Performed": "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy"]

define "Encounter with Thrombolytic Therapy Given Prior To Arrival Or During Hospitalization":
  "Encounter with Thrombolytic Therapy Medication or Procedures"
    union "Encounter with Thrombolytic Therapy Prior to Arrival"
    union "Encounter with Thrombolytic Therapy Documented As Already Given"

define "Denominator":
  TJC."Ischemic Stroke Encounter"

define "Denominator Exceptions":
  "No Antithrombotic Ordered or Administered Day Of or Day After Hospital Arrival"
    union "Encounter with Pharmacological Contraindications for Antithrombotic Therapy Given Day Of or Day After Hospital Arrival"
    union "Encounter with An INR Greater Than 3.5"

define "Denominator Exclusions":
  "Encounter Less Than Two Days"
    union "Encounter with Comfort Measures during Day of or Day After Arrival"
    union "Encounter with Thrombolytic Therapy Given Prior To Arrival Or During Hospitalization"

define "Encounter Less Than Two Days":
  TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    where Global."HospitalizationWithObservationLengthofStay" ( IschemicStrokeEncounter ) < 2

define "Encounter with Thrombolytic Therapy Medication or Procedures":
  TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    with "Thrombolytic Therapy Medication or Procedures" ThrombolyticTherapy
      such that Global."NormalizeInterval" ( ThrombolyticTherapy.relevantDatetime, ThrombolyticTherapy.relevantPeriod ) starts during Interval[start of Global."HospitalizationWithObservation" ( IschemicStrokeEncounter ) - 24 hours, 
      end of Global."HospitalizationWithObservation" ( IschemicStrokeEncounter ) )

define "Encounter with Thrombolytic Therapy Documented As Already Given":
  TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    with [Diagnosis: "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"] PriorTPA
      such that PriorTPA.authorDatetime during Global."HospitalizationWithObservation" ( IschemicStrokeEncounter )

define "Encounter with Thrombolytic Therapy Prior to Arrival":
  TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    where exists IschemicStrokeEncounter.diagnoses Diagnosis
      where Diagnosis.code in "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"

define "Reason for Not Ordering Antithrombotic":
  ["Medication, Not Ordered": "Antithrombotic Therapy"] NoAntithromboticOrder
    where NoAntithromboticOrder.negationRationale in "Medical Reason"
      or NoAntithromboticOrder.negationRationale in "Patient Refusal"

define "Reason for Not Administering Antithrombotic":
  ["Medication, Not Administered": "Antithrombotic Therapy"] NoAntithromboticGiven
    where NoAntithromboticGiven.negationRationale in "Medical Reason"
      or NoAntithromboticGiven.negationRationale in "Patient Refusal"

define "Encounter with An INR Greater Than 3.5":
  TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    with ["Laboratory Test, Performed": "INR"] INR
      such that INR.resultDatetime during day of TJC."CalendarDayOfOrDayAfter" ( start of Global."HospitalizationWithObservation" ( IschemicStrokeEncounter ) )
        and INR.result > 3.5

define "Encounter with Antithrombotic Therapy":
  TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    with ["Medication, Administered": "Antithrombotic Therapy"] Antithrombotic
      such that Global."NormalizeInterval" ( Antithrombotic.relevantDatetime, Antithrombotic.relevantPeriod ) starts during day of TJC."CalendarDayOfOrDayAfter" ( start of Global."HospitalizationWithObservation" ( IschemicStrokeEncounter ) )

define "Encounter with Comfort Measures during Day of or Day After Arrival":
  TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    with TJC."Intervention Comfort Measures" ComfortMeasures
      such that Coalesce(start of Global."NormalizeInterval"(ComfortMeasures.relevantDatetime, ComfortMeasures.relevantPeriod), ComfortMeasures.authorDatetime)during day of TJC."CalendarDayOfOrDayAfter" ( start of Global."HospitalizationWithObservation" ( IschemicStrokeEncounter ) )

define "Encounter with Pharmacological Contraindications for Antithrombotic Therapy Given Day Of or Day After Hospital Arrival":
  TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    with ["Medication, Administered": "Pharmacological Contraindications For Antithrombotic Therapy"] PharmacologicalContraindications
      such that Global."NormalizeInterval" ( PharmacologicalContraindications.relevantDatetime, PharmacologicalContraindications.relevantPeriod ) starts during day of TJC."CalendarDayOfOrDayAfter" ( start of Global."HospitalizationWithObservation" ( IschemicStrokeEncounter ) )

define "No Antithrombotic Ordered or Administered":
  "Reason for Not Ordering Antithrombotic"
    union "Reason for Not Administering Antithrombotic"

define "No Antithrombotic Ordered or Administered Day Of or Day After Hospital Arrival":
  TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    with "No Antithrombotic Ordered or Administered" NoAntithrombotic
      such that NoAntithrombotic.authorDatetime during day of TJC."CalendarDayOfOrDayAfter" ( start of Global."HospitalizationWithObservation" ( IschemicStrokeEncounter ) )