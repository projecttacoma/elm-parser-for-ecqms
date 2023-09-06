library HybridHospitalWideMortality version '4.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

valueset "Bicarbonate lab test": 'urn:oid:2.16.840.1.113762.1.4.1045.139'
valueset "Body temperature": 'urn:oid:2.16.840.1.113762.1.4.1045.152'
valueset "Creatinine lab test": 'urn:oid:2.16.840.1.113883.3.666.5.2363'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Heart Rate": 'urn:oid:2.16.840.1.113762.1.4.1045.149'
valueset "Hematocrit lab test": 'urn:oid:2.16.840.1.113762.1.4.1045.114'
valueset "Medicare Advantage payer": 'urn:oid:2.16.840.1.113762.1.4.1104.12'
valueset "Medicare FFS payer": 'urn:oid:2.16.840.1.113762.1.4.1104.10'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Oxygen Saturation by Pulse Oximetry": 'urn:oid:2.16.840.1.113762.1.4.1045.151'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Platelet count lab test": 'urn:oid:2.16.840.1.113762.1.4.1045.127'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Sodium lab test": 'urn:oid:2.16.840.1.113762.1.4.1045.119'
valueset "Systolic Blood Pressure": 'urn:oid:2.16.840.1.113762.1.4.1045.163'
valueset "White blood cells count lab test": 'urn:oid:2.16.840.1.113762.1.4.1045.129'

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

define "Initial Population":
  "Inpatient Encounters"

define "SDE Results":
  {
  // First physical exams
    FirstHeartRate: "FirstPhysicalExamWithEncounterId"(["Physical Exam, Performed": "Heart Rate"]),
    FirstSystolicBloodPressure: "FirstPhysicalExamWithEncounterId"(["Physical Exam, Performed": "Systolic Blood Pressure"]),
    FirstBodyTemperature: "FirstPhysicalExamWithEncounterId"(["Physical Exam, Performed": "Body temperature"]),
    FirstOxygenSaturation: "FirstPhysicalExamWithEncounterId"(["Physical Exam, Performed": "Oxygen Saturation by Pulse Oximetry"]),
  
  // First lab tests
    FirstHematocritLab: "FirstLabTestWithEncounterId"(["Laboratory Test, Performed": "Hematocrit lab test"]),
    FirstPlateletCount: "FirstLabTestWithEncounterId"(["Laboratory Test, Performed": "Platelet count lab test"]),
    FirstWhiteBloodCellCount: "FirstLabTestWithEncounterId"(["Laboratory Test, Performed": "White blood cells count lab test"]),
    FirstSodiumLab: "FirstLabTestWithEncounterId"(["Laboratory Test, Performed": "Sodium lab test"]),
    FirstBicarbonateLab: "FirstLabTestWithEncounterId"(["Laboratory Test, Performed": "Bicarbonate lab test"]),
    FirstCreatinineLab: "FirstLabTestWithEncounterId"(["Laboratory Test, Performed": "Creatinine lab test"])
  }

define "Inpatient Encounters":
  ["Encounter, Performed": "Encounter Inpatient"] InpatientEncounter
    with ( ["Patient Characteristic Payer": "Medicare FFS payer"]
      union ["Patient Characteristic Payer": "Medicare Advantage payer"] ) Payer
      such that Global."HospitalizationWithObservationLengthofStay" ( InpatientEncounter ) < 365
        and InpatientEncounter.relevantPeriod ends during day of "Measurement Period"
        and AgeInYearsAt(date from start of InpatientEncounter.relevantPeriod)in Interval[65, 94]

define function "FirstLabTestWithEncounterId"(LabList List<QDM.PositiveLaboratoryTestPerformed>):
  "Inpatient Encounters" Encounter
    let FirstLab: First(LabList Lab
        where Lab.resultDatetime during Interval[start of Encounter.relevantPeriod - 1440 minutes, start of Encounter.relevantPeriod + 1440 minutes]
        sort by resultDatetime
    )
    return {
      EncounterId: Encounter.id,
      FirstResult: FirstLab.result as Quantity,
      Timing: FirstLab.resultDatetime
    }

define function "FirstPhysicalExamWithEncounterId"(ExamList List<QDM.PositivePhysicalExamPerformed>):
  "Inpatient Encounters" Encounter
    let FirstExam: First(ExamList Exam
        where Global."EarliestOf"(Exam.relevantDatetime, Exam.relevantPeriod)during Interval[start of Encounter.relevantPeriod - 1440 minutes, start of Encounter.relevantPeriod + 120 minutes]
        sort by Global."EarliestOf"(relevantDatetime, relevantPeriod)
    )
    return {
      EncounterId: Encounter.id,
      FirstResult: FirstExam.result as Quantity,
      Timing: Global."EarliestOf" ( FirstExam.relevantDatetime, FirstExam.relevantPeriod )
    }