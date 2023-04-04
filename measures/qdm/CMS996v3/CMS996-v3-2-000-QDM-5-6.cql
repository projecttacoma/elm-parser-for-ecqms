library AppropriateTreatmentforSTEMI version '3.2.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

valueset "Active Bleeding or Bleeding Diathesis (Excluding Menses)": 'urn:oid:2.16.840.1.113883.3.3157.4036'
valueset "Active Peptic Ulcer": 'urn:oid:2.16.840.1.113883.3.3157.4031'
valueset "Adverse reaction to thrombolytics": 'urn:oid:2.16.840.1.113762.1.4.1170.6'
valueset "Allergy to thrombolytics": 'urn:oid:2.16.840.1.113762.1.4.1170.5'
valueset "Anticoagulant Medications, Oral": 'urn:oid:2.16.840.1.113883.3.3157.4045'
valueset "Aortic Dissection and Rupture": 'urn:oid:2.16.840.1.113883.3.3157.4028'
valueset "Cardiopulmonary Arrest": 'urn:oid:2.16.840.1.113883.3.3157.4048'
valueset "Cerebral Vascular Lesion": 'urn:oid:2.16.840.1.113883.3.3157.4025'
valueset "Closed Head and Facial Trauma": 'urn:oid:2.16.840.1.113883.3.3157.4026'
valueset "Dementia": 'urn:oid:2.16.840.1.113883.3.3157.4043'
valueset "Discharge To Acute Care Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'
valueset "Emergency Department Visit (1010)": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Endotracheal Intubation": 'urn:oid:2.16.840.1.113762.1.4.1045.69'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Fibrinolytic Therapy": 'urn:oid:2.16.840.1.113883.3.3157.4019'
valueset "Intracranial or Intraspinal surgery": 'urn:oid:2.16.840.1.113762.1.4.1170.2'
valueset "Ischemic Stroke": 'urn:oid:2.16.840.1.113883.3.464.1003.104.12.1024'
valueset "Major Surgical Procedure": 'urn:oid:2.16.840.1.113883.3.3157.4056'
valueset "Malignant Intracranial Neoplasm Group": 'urn:oid:2.16.840.1.113762.1.4.1170.3'
valueset "Mechanical Circulatory Assist Device": 'urn:oid:2.16.840.1.113883.3.3157.4052'
valueset "Neurologic impairment": 'urn:oid:2.16.840.1.113883.3.464.1003.114.12.1012'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Percutaneous Coronary Intervention": 'urn:oid:2.16.840.1.113883.3.3157.2000.5'
valueset "Pregnancy": 'urn:oid:2.16.840.1.113883.3.3157.4055'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "STEMI": 'urn:oid:2.16.840.1.113883.3.3157.4017'
valueset "Thrombolytic medications": 'urn:oid:2.16.840.1.113762.1.4.1170.4'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

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

define "Active Exclusion Diagnosis at Start of ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ( ["Diagnosis": "Active Bleeding or Bleeding Diathesis (Excluding Menses)"]
      union ["Diagnosis": "Malignant Intracranial Neoplasm Group"]
      union ["Diagnosis": "Cerebral Vascular Lesion"]
      union ["Diagnosis": "Dementia"]
      union ["Diagnosis": "Pregnancy"]
      union ["Diagnosis": "Allergy to thrombolytics"] ) ActiveExclusionDx
      such that ActiveExclusionDx.prevalencePeriod overlaps before EDwSTEMI.relevantPeriod

define "Active Oral Anticoagulant Medication Overlaps Before ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Medication, Active": "Anticoagulant Medications, Oral"] OralAnticoagulant
      such that Global."NormalizeInterval" ( OralAnticoagulant.relevantDatetime, OralAnticoagulant.relevantPeriod ) overlaps before EDwSTEMI.relevantPeriod

define "Adverse Effect to Thrombolytic Medications Before End of ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Adverse Event": "Thrombolytic medications"] ThrombolyticAdverseEvent
      such that ThrombolyticAdverseEvent.type in "Adverse reaction to thrombolytics"
        and ThrombolyticAdverseEvent.relevantDatetime before 
        end of EDwSTEMI.relevantPeriod

define "Allergy or Intolerance to Thrombolytic Medications Overlaps ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Allergy/Intolerance": "Thrombolytic medications"] ThrombolyticAllergy
      such that ThrombolyticAllergy.prevalencePeriod overlaps EDwSTEMI.relevantPeriod

define "ED Encounter with Expired Discharge Disposition":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    where EDwSTEMI.dischargeDisposition in "Patient Expired"

define "Intracranial or Intraspinal Procedure 90 Days or Less Before Start of ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Procedure, Performed": "Intracranial or Intraspinal surgery"] CranialorSpinalSurgery
      such that Global."NormalizeInterval" ( CranialorSpinalSurgery.relevantDatetime, CranialorSpinalSurgery.relevantPeriod ) starts 90 days or less before start of EDwSTEMI.relevantPeriod

define "Major Surgical Procedure 21 Days or Less Before End of ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Procedure, Performed": "Major Surgical Procedure"] MajorSurgery
      such that Global."NormalizeInterval" ( MajorSurgery.relevantDatetime, MajorSurgery.relevantPeriod ) starts 21 days or less before 
      end of EDwSTEMI.relevantPeriod

define "Intubation or Mechanical Circulatory Assist Procedure During ED Encounter or Within 24 Hours of ED Encounter Start":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ( ["Procedure, Performed": "Endotracheal Intubation"]
      union ["Procedure, Performed": "Mechanical Circulatory Assist Device"] ) AirwayProcedure
      such that ( Global."NormalizeInterval" ( AirwayProcedure.relevantDatetime, AirwayProcedure.relevantPeriod ) starts during EDwSTEMI.relevantPeriod
          or Global."NormalizeInterval" ( AirwayProcedure.relevantDatetime, AirwayProcedure.relevantPeriod ) starts 24 hours or less before start of EDwSTEMI.relevantPeriod
      )

define "Initial Population":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    where AgeInYearsAt(date from start of EDwSTEMI.relevantPeriod)>= 18

define "PCI within 90 Minutes of Arrival":
  /*The definition "ED Encounter with STEMI Diagnosis" uses OID 2.16.840.1.113883.3.464.1003.101.12.1010 to define "Emergency Department Visit". Instances of "Emergency Department Visit" associated with the Global Common Library, "Global", should use OID 2.16.840.1.113883.3.117.1.7.1.292*/
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Procedure, Performed": "Percutaneous Coronary Intervention"] PCI
      such that Global."NormalizeInterval" ( PCI.relevantDatetime, PCI.relevantPeriod ) starts 90 minutes or less after Global."EmergencyDepartmentArrivalTime" ( EDwSTEMI )

define "ED Departure with Transfer to Acute Care Facility Within 45 Minutes of Arrival":
  /*The definition "ED Encounter with STEMI Diagnosis" uses OID 2.16.840.1.113883.3.464.1003.101.12.1010 to define "Emergency Department Visit". Instances of "Emergency Department Visit" associated with the Global Common Library, "Global", should use OID 2.16.840.1.113883.3.117.1.7.1.292*/
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ( Global."HospitalDepartureTime" ( EDwSTEMI ) ) Departure
      such that Departure 45 minutes or less after Global."EmergencyDepartmentArrivalTime" ( EDwSTEMI )
        and EDwSTEMI.dischargeDisposition in "Discharge To Acute Care Facility"

define "ED Encounter with STEMI Diagnosis":
  /*The definitions "ED Encounter with Encounter Diagnosis of STEMI" and "ED Encounter with Diagnosis of STEMI" both use OID 2.16.840.1.113883.3.464.1003.101.12.1010 to define "Emergency Department Visit". This OID should be applied for all instances of "Emergency Department Visit" value set when "ED Encounter with STEMI Diagnosis" definition is applied.*/
  "ED Encounter with Encounter Diagnosis of STEMI"
    union "ED Encounter with Diagnosis of STEMI"

define "Active Exclusion Diagnosis Within 90 Days Before Start of ED Encounter":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ( ["Diagnosis": "Ischemic Stroke"]
      union ["Diagnosis": "Closed Head and Facial Trauma"]
      union ["Diagnosis": "Active Peptic Ulcer"] ) DxExclusion
      such that ( DxExclusion.prevalencePeriod overlaps Interval[start of EDwSTEMI.relevantPeriod - 90 days, start of EDwSTEMI.relevantPeriod])

define "Exclusion Diagnosis During ED Encounter or Within 24 Hours of ED Encounter Start":
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ( ["Diagnosis": "Aortic Dissection and Rupture"]
      union ["Diagnosis": "Neurologic impairment"]
      union ["Diagnosis": "Cardiopulmonary Arrest"] ) ExclusionDx
      such that ( ExclusionDx.prevalencePeriod starts during EDwSTEMI.relevantPeriod
          or ExclusionDx.prevalencePeriod starts 24 hours or less before start of EDwSTEMI.relevantPeriod
      )

define "Denominator Exclusions":
  "Exclusion Diagnosis During ED Encounter or Within 24 Hours of ED Encounter Start"
    union "Intubation or Mechanical Circulatory Assist Procedure During ED Encounter or Within 24 Hours of ED Encounter Start"
    union "Major Surgical Procedure 21 Days or Less Before End of ED Encounter"
    union "Active Exclusion Diagnosis at Start of ED Encounter"
    union "Intracranial or Intraspinal Procedure 90 Days or Less Before Start of ED Encounter"
    union "Active Oral Anticoagulant Medication Overlaps Before ED Encounter"
    union "Active Exclusion Diagnosis Within 90 Days Before Start of ED Encounter"
    union "Allergy or Intolerance to Thrombolytic Medications Overlaps ED Encounter"
    union "Adverse Effect to Thrombolytic Medications Before End of ED Encounter"
    union "ED Encounter with Expired Discharge Disposition"

define "Fibrinolytic Therapy Within 30 Minutes of Arrival":
  /*The definition "ED Encounter with STEMI Diagnosis" uses OID 2.16.840.1.113883.3.464.1003.101.12.1010 to define "Emergency Department Visit". Instances of "Emergency Department Visit" associated with the Global Common Library, "Global", should use OID 2.16.840.1.113883.3.117.1.7.1.292*/
  "ED Encounter with STEMI Diagnosis" EDwSTEMI
    with ["Medication, Administered": "Fibrinolytic Therapy"] Fibrinolytic
      such that Global."NormalizeInterval" ( Fibrinolytic.relevantDatetime, Fibrinolytic.relevantPeriod ) starts 30 minutes or less after Global."EmergencyDepartmentArrivalTime" ( EDwSTEMI )

define "ED Encounter with Diagnosis of STEMI":
  /*The below instance of "Emergency Department Visit" corresponds to OID 2.16.840.1.113883.3.464.1003.101.12.1010 and this OID should be used where this definition is used*/
  ["Encounter, Performed": "Emergency Department Visit (1010)"] EDEncounter
    with ["Diagnosis": "STEMI"] DxSTEMI
      such that ( DxSTEMI.prevalencePeriod starts during EDEncounter.relevantPeriod )
        and EDEncounter.relevantPeriod during "Measurement Period"

define "ED Encounter with Encounter Diagnosis of STEMI":
  /*The below instance of "Emergency Department Visit" corresponds to OID 2.16.840.1.113883.3.464.1003.101.12.1010 and this OID should be used where this definition is used*/
  ["Encounter, Performed": "Emergency Department Visit (1010)"] EDEncounter
    with EDEncounter.diagnoses EncounterDiagnosis
      such that EncounterDiagnosis.code in "STEMI"
        and EDEncounter.relevantPeriod during "Measurement Period"