library AppropriateTreatmentforSTEMI version '4.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

valueset "Active Bleeding Excluding Menses or Bleeding Diathesis": 'urn:oid:2.16.840.1.113883.3.3157.4036'
valueset "Acute Peptic Ulcer": 'urn:oid:2.16.840.1.113883.3.3157.4031'
valueset "Allergy to thrombolytics": 'urn:oid:2.16.840.1.113762.1.4.1170.5'
valueset "Aortic Dissection or Ruptured Aortic Aneurysm": 'urn:oid:2.16.840.1.113883.3.3157.4028'
valueset "Cardiopulmonary Arrest": 'urn:oid:2.16.840.1.113883.3.3157.4048'
valueset "Cerebral Vascular Lesion": 'urn:oid:2.16.840.1.113883.3.3157.4025'
valueset "Closed Head and Facial Trauma": 'urn:oid:2.16.840.1.113883.3.3157.4026'
valueset "Dementia and Related Intracranial Pathologies": 'urn:oid:2.16.840.1.113883.3.3157.4043'
valueset "Discharge To Acute Care Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'
valueset "Emergency Department Evaluation and Management Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Endotracheal Intubation": 'urn:oid:2.16.840.1.113762.1.4.1045.69'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Fibrinolytic Therapy": 'urn:oid:2.16.840.1.113883.3.3157.4019'
valueset "Insertion or Replacement of Mechanical Circulatory Assist Device": 'urn:oid:2.16.840.1.113883.3.3157.4052'
valueset "Intracranial or Intraspinal surgery": 'urn:oid:2.16.840.1.113762.1.4.1170.2'
valueset "Ischemic Stroke": 'urn:oid:2.16.840.1.113883.3.464.1003.104.12.1024'
valueset "Major Surgical Procedure": 'urn:oid:2.16.840.1.113883.3.3157.4056'
valueset "Malignant Intracranial Neoplasm Group": 'urn:oid:2.16.840.1.113762.1.4.1170.3'
valueset "Neurologic impairment": 'urn:oid:2.16.840.1.113883.3.464.1003.114.12.1012'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Oral Anticoagulant Medications": 'urn:oid:2.16.840.1.113883.3.3157.4045'
valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Percutaneous Coronary Intervention": 'urn:oid:2.16.840.1.113883.3.3157.2000.5'
valueset "Pregnancy": 'urn:oid:2.16.840.1.113883.3.3157.4055'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "STEMI": 'urn:oid:2.16.840.1.113883.3.3157.4017'
valueset "Thrombolytic medications": 'urn:oid:2.16.840.1.113762.1.4.1170.4'
valueset "Thrombolytics Adverse Event": 'urn:oid:2.16.840.1.113762.1.4.1170.6'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Denominator":
  "Initial Population"

define "Numerator":
  ( "Fibrinolytic Therapy Within 30 Minutes of Arrival"
      union "PCI within 90 Minutes of Arrival"
      union "ED Departure with Transfer to Acute Care Facility Within 45 Minutes of Arrival"
  )

define "Allergy or Intolerance to Thrombolytic Medications Overlaps ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Allergy/Intolerance": "Thrombolytic medications"] ThrombolyticAllergy
      such that ThrombolyticAllergy.prevalencePeriod overlaps EDwSTEMI.relevantPeriod

define "Adverse Effect to Thrombolytic Medications Before End of ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Adverse Event": "Thrombolytic medications"] ThrombolyticAdverseEvent
      such that ThrombolyticAdverseEvent.type in "Thrombolytics Adverse Event"
        and ThrombolyticAdverseEvent.relevantDatetime before 
        end of EDwSTEMI.relevantPeriod

define "Initial Population":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    where AgeInYearsAt(date from start of EDwSTEMI.relevantPeriod)>= 18

define "ED Encounter with Discharge Disposition as Patient Expired":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    where EDwSTEMI.dischargeDisposition in "Patient Expired"

define "ED Encounter with Diagnosis of STEMI":
  ["Encounter, Performed": "Emergency Department Evaluation and Management Visit"] EDEncounter
    with ["Diagnosis": "STEMI"] DxSTEMI
      such that ( DxSTEMI.prevalencePeriod starts during EDEncounter.relevantPeriod )
        and EDEncounter.relevantPeriod ends during day of "Measurement Period"

define "ED Encounter with Encounter Diagnosis of STEMI":
  ["Encounter, Performed": "Emergency Department Evaluation and Management Visit"] EDEncounter
    with EDEncounter.diagnoses EncounterDiagnosis
      such that EncounterDiagnosis.code in "STEMI"
        and EDEncounter.relevantPeriod ends during day of "Measurement Period"

define "ED Encounter with STEMI Diagnosis":
  "ED Encounter with Encounter Diagnosis of STEMI"
    union "ED Encounter with Diagnosis of STEMI"

define "Active Exclusion Diagnosis at Start of ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ( ["Diagnosis": "Active Bleeding Excluding Menses or Bleeding Diathesis"]
      union ["Diagnosis": "Malignant Intracranial Neoplasm Group"]
      union ["Diagnosis": "Cerebral Vascular Lesion"]
      union ["Diagnosis": "Dementia and Related Intracranial Pathologies"]
      union ["Diagnosis": "Pregnancy"]
      union ["Diagnosis": "Allergy to thrombolytics"] ) ActiveExclusionDx
      such that ActiveExclusionDx.prevalencePeriod overlaps before EDwSTEMI.relevantPeriod

define "Active Exclusion Diagnosis Within 90 Days Before or At the Start of ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ( ["Diagnosis": "Ischemic Stroke"]
      union ["Diagnosis": "Closed Head and Facial Trauma"]
      union ["Diagnosis": "Acute Peptic Ulcer"] ) DxExclusion
      such that ( DxExclusion.prevalencePeriod starts during Interval[start of EDwSTEMI.relevantPeriod - 90 days, start of EDwSTEMI.relevantPeriod])

define "ED Departure with Transfer to Acute Care Facility Within 45 Minutes of Arrival":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ( Global."HospitalDepartureTime" ( EDwSTEMI ) ) Departure
      such that Departure 45 minutes or less after Global."EmergencyDepartmentArrivalTime" ( EDwSTEMI )
        and EDwSTEMI.dischargeDisposition in "Discharge To Acute Care Facility"

define "Exclusion Diagnosis During ED Encounter or Within 24 Hours of ED Encounter Start":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ( ["Diagnosis": "Aortic Dissection or Ruptured Aortic Aneurysm"]
      union ["Diagnosis": "Neurologic impairment"]
      union ["Diagnosis": "Cardiopulmonary Arrest"] ) ExclusionDx
      such that ( ExclusionDx.prevalencePeriod starts during EDwSTEMI.relevantPeriod
          or ExclusionDx.prevalencePeriod starts 24 hours or less before start of EDwSTEMI.relevantPeriod
      )

define "PCI within 90 Minutes of Arrival":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Procedure, Performed": "Percutaneous Coronary Intervention"] PCI
      such that Global."NormalizeInterval" ( PCI.relevantDatetime, PCI.relevantPeriod ) starts 90 minutes or less after Global."EmergencyDepartmentArrivalTime" ( EDwSTEMI )

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "Major Surgical Procedure 21 Days or Less Before Start of or Starts During ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Procedure, Performed": "Major Surgical Procedure"] MajorSurgery
      such that Global."NormalizeInterval" ( MajorSurgery.relevantDatetime, MajorSurgery.relevantPeriod ) starts 21 days or less before start of EDwSTEMI.relevantPeriod
        or Global."NormalizeInterval" ( MajorSurgery.relevantDatetime, MajorSurgery.relevantPeriod ) starts during EDwSTEMI.relevantPeriod

define "Intubation or Mechanical Circulatory Assist Procedure During ED Encounter or Within 24 Hours of ED Encounter Start":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ( ["Procedure, Performed": "Endotracheal Intubation"]
      union ["Procedure, Performed": "Insertion or Replacement of Mechanical Circulatory Assist Device"] ) AirwayProcedure
      such that ( Global."NormalizeInterval" ( AirwayProcedure.relevantDatetime, AirwayProcedure.relevantPeriod ) starts during EDwSTEMI.relevantPeriod
          or Global."NormalizeInterval" ( AirwayProcedure.relevantDatetime, AirwayProcedure.relevantPeriod ) starts 24 hours or less before start of EDwSTEMI.relevantPeriod
      )

define "Intracranial or Intraspinal Procedure 90 Days or Less Before Start of ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Procedure, Performed": "Intracranial or Intraspinal surgery"] CranialorSpinalSurgery
      such that Global."NormalizeInterval" ( CranialorSpinalSurgery.relevantDatetime, CranialorSpinalSurgery.relevantPeriod ) starts 90 days or less before start of EDwSTEMI.relevantPeriod

define "Fibrinolytic Therapy Within 30 Minutes of Arrival":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Medication, Administered": "Fibrinolytic Therapy"] Fibrinolytic
      such that Global."NormalizeInterval" ( Fibrinolytic.relevantDatetime, Fibrinolytic.relevantPeriod ) starts 30 minutes or less after Global."EmergencyDepartmentArrivalTime" ( EDwSTEMI )

define "Denominator Exclusions":
  "Allergy or Intolerance to Thrombolytic Medications Overlaps ED Encounter"
    union "Adverse Effect to Thrombolytic Medications Before End of ED Encounter"
    union "Active Exclusion Diagnosis at Start of ED Encounter"
    union "Active Oral Anticoagulant Medication at the Start of ED Encounter"
    union "Exclusion Diagnosis During ED Encounter or Within 24 Hours of ED Encounter Start"
    union "Major Surgical Procedure 21 Days or Less Before Start of or Starts During ED Encounter"
    union "Intubation or Mechanical Circulatory Assist Procedure During ED Encounter or Within 24 Hours of ED Encounter Start"
    union "Active Exclusion Diagnosis Within 90 Days Before or At the Start of ED Encounter"
    union "Intracranial or Intraspinal Procedure 90 Days or Less Before Start of ED Encounter"
    union "ED Encounter with Discharge Disposition as Patient Expired"

define "Active Oral Anticoagulant Medication at the Start of ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Medication, Active": "Oral Anticoagulant Medications"] OralAnticoagulant
      such that ( Global.HasStart ( OralAnticoagulant.relevantPeriod )
          and OralAnticoagulant.relevantPeriod starts before or on start of EDwSTEMI.relevantPeriod
          and OralAnticoagulant.relevantPeriod ends on or after start of EDwSTEMI.relevantPeriod
      )
        or ( OralAnticoagulant.relevantDatetime before or on EDwSTEMI.relevantPeriod )