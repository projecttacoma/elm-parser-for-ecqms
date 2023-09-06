library SafeUseofOpioidsConcurrentPrescribing version '6.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

valueset "All Primary and Secondary Cancer": 'urn:oid:2.16.840.1.113762.1.4.1111.161'
valueset "Discharge To Acute Care Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hospice Care Referral or Admission": 'urn:oid:2.16.840.1.113762.1.4.1116.365'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Palliative or Hospice Care": 'urn:oid:2.16.840.1.113883.3.600.1.1579'
valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Schedule II & III Opioid Medications": 'urn:oid:2.16.840.1.113762.1.4.1111.165'
valueset "Schedule IV Benzodiazepines": 'urn:oid:2.16.840.1.113762.1.4.1125.1'

context Patient

define "Denominator":
  "Initial Population"

define "Inpatient Encounter with Age Greater than or Equal to 18":
  Global."Inpatient Encounter" InpatientHospitalEncounter
    where AgeInYearsAt(date from start of InpatientHospitalEncounter.relevantPeriod)>= 18

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Intervention Palliative or Hospice Care":
  ["Intervention, Order": "Palliative or Hospice Care"]
    union ["Intervention, Performed": "Palliative or Hospice Care"]

define "Inpatient Encounters with an Opioid or Benzodiazepine at Discharge":
  /*Captures encounters of patients with an opioid(s), benzodiazepine, or a combination of these medications at discharge*/
  "Inpatient Encounter with Age Greater than or Equal to 18" InpatientEncounter
    with ( ["Medication, Discharge": "Schedule II & III Opioid Medications"]
      union ["Medication, Discharge": "Schedule IV Benzodiazepines"] ) OpioidOrBenzodiazepineDischargeMedication
      such that OpioidOrBenzodiazepineDischargeMedication.authorDatetime during InpatientEncounter.relevantPeriod

define "Initial Population":
  "Inpatient Encounters with an Opioid or Benzodiazepine at Discharge"

define "Numerator":
  /*Encounters of patients prescribed two or more opioids or an opioid and benzodiazepine at discharge.
  */
  ( "Inpatient Encounters with an Opioid or Benzodiazepine at Discharge" InpatientEncounter
      where ( Count(["Medication, Discharge": "Schedule II & III Opioid Medications"] Opioids
            where Opioids.authorDatetime during InpatientEncounter.relevantPeriod
            return distinct Opioids.code
        )>= 2
      )
  )
    union ( "Inpatient Encounters with an Opioid or Benzodiazepine at Discharge" InpatientEncounter
        with ["Medication, Discharge": "Schedule II & III Opioid Medications"] OpioidsDischarge
          such that OpioidsDischarge.authorDatetime during InpatientEncounter.relevantPeriod
        with ["Medication, Discharge": "Schedule IV Benzodiazepines"] BenzodiazepinesDischarge
          such that BenzodiazepinesDischarge.authorDatetime during InpatientEncounter.relevantPeriod
    )

define "Denominator Exclusion":
  /*Excludes encounters of patients with cancer or who are receiving palliative or hospice care at the time of the encounter or who are discharged to another inpatient care facility or expire during the inpatient stay*/
  "Inpatient Encounters with an Opioid or Benzodiazepine at Discharge" InpatientEncounter
    where exists ( ["Diagnosis": "All Primary and Secondary Cancer"] Cancer
        where Cancer.prevalencePeriod overlaps InpatientEncounter.relevantPeriod
    )
      or exists ( InpatientEncounter.diagnoses Diagnosis
          where Diagnosis.code in "All Primary and Secondary Cancer"
      )
      or exists ( "Intervention Palliative or Hospice Care" PalliativeOrHospiceCare
          where Coalesce(start of Global."NormalizeInterval"(PalliativeOrHospiceCare.relevantDatetime, PalliativeOrHospiceCare.relevantPeriod), PalliativeOrHospiceCare.authorDatetime)during Global."HospitalizationWithObservation" ( InpatientEncounter )
      )
      or ( InpatientEncounter.dischargeDisposition in "Discharge To Acute Care Facility"
          or InpatientEncounter.dischargeDisposition in "Hospice Care Referral or Admission"
          or InpatientEncounter.dischargeDisposition in "Patient Expired"
      )