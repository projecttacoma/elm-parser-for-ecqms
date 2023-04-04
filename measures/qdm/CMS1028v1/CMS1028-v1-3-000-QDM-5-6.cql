library SevereObstetricComplications version '1.3.000'

using QDM version '5.6'

include PCMaternal version '2.21.000' called PCMaternal
include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Anemia": 'urn:oid:2.16.840.1.113762.1.4.1029.323'
valueset "Asthma": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.271'
valueset "Autoimmune Disease": 'urn:oid:2.16.840.1.113762.1.4.1029.311'
valueset "Bariatric Surgery": 'urn:oid:2.16.840.1.113762.1.4.1029.317'
valueset "Bleeding Disorder": 'urn:oid:2.16.840.1.113762.1.4.1029.287'
valueset "Blood Transfusion": 'urn:oid:2.16.840.1.113762.1.4.1029.213'
valueset "BMI >= 40": 'urn:oid:2.16.840.1.113762.1.4.1029.290'
valueset "Cardiac Disease": 'urn:oid:2.16.840.1.113762.1.4.1029.341'
valueset "COVID 19 Confirmed": 'urn:oid:2.16.840.1.113762.1.4.1029.373'
valueset "Economic Housing Instability": 'urn:oid:2.16.840.1.113762.1.4.1029.292'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Gastrointestinal Disease": 'urn:oid:2.16.840.1.113762.1.4.1029.338'
valueset "Gestational Diabetes": 'urn:oid:2.16.840.1.113762.1.4.1029.269'
valueset "Hematocrit lab test": 'urn:oid:2.16.840.1.113762.1.4.1045.114'
valueset "HIV": 'urn:oid:2.16.840.1.113762.1.4.1029.272'
valueset "Hypertension": 'urn:oid:2.16.840.1.113762.1.4.1029.332'
valueset "Long Term Anticoagulant Use": 'urn:oid:2.16.840.1.113762.1.4.1029.366'
valueset "Mental Health Disorder": 'urn:oid:2.16.840.1.113762.1.4.1029.314'
valueset "Multiple Pregnancy": 'urn:oid:2.16.840.1.113762.1.4.1029.284'
valueset "Neuromuscular Disease": 'urn:oid:2.16.840.1.113762.1.4.1029.308'
valueset "Obstetrical VTE": 'urn:oid:2.16.840.1.113762.1.4.1029.363'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Other Preeclampsia": 'urn:oid:2.16.840.1.113762.1.4.1029.329'
valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Placenta Previa": 'urn:oid:2.16.840.1.113762.1.4.1110.35'
valueset "Placental Abruption": 'urn:oid:2.16.840.1.113762.1.4.1029.305'
valueset "Placental Accreta Spectrum": 'urn:oid:2.16.840.1.113762.1.4.1029.302'
valueset "Preexisting Diabetes": 'urn:oid:2.16.840.1.113762.1.4.1029.275'
valueset "Present on Admission = No or Unable To Determine": 'urn:oid:2.16.840.1.113762.1.4.1029.370'
valueset "Present On Admission = Yes or Exempt": 'urn:oid:2.16.840.1.113762.1.4.1110.63'
valueset "Preterm Birth": 'urn:oid:2.16.840.1.113762.1.4.1029.299'
valueset "Previous Cesarean": 'urn:oid:2.16.840.1.113762.1.4.1029.278'
valueset "Pulmonary Hypertension": 'urn:oid:2.16.840.1.113762.1.4.1029.281'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Renal Disease": 'urn:oid:2.16.840.1.113762.1.4.1029.335'
valueset "Respiratory Conditions Related to COVID 19": 'urn:oid:2.16.840.1.113762.1.4.1029.376'
valueset "Respiratory Support Procedures Related to COVID 19": 'urn:oid:2.16.840.1.113762.1.4.1029.379'
valueset "Severe Maternal Morbidity Diagnoses": 'urn:oid:2.16.840.1.113762.1.4.1029.255'
valueset "Severe Maternal Morbidity Procedures": 'urn:oid:2.16.840.1.113762.1.4.1029.256'
valueset "Severe Preeclampsia": 'urn:oid:2.16.840.1.113762.1.4.1029.327'
valueset "Substance Abuse": 'urn:oid:2.16.840.1.113762.1.4.1029.320'
valueset "Thyrotoxicosis": 'urn:oid:2.16.840.1.113762.1.4.1029.296'
valueset "White blood cells count lab test": 'urn:oid:2.16.840.1.113762.1.4.1045.129'

code "Heart rate": '8867-4' from "LOINC" display 'Heart rate'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'

context Patient

define "Denominator":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation"

define "Initial Population":
  PCMaternal."Delivery Encounter with Age Range"

define "Risk Variable Asthma":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Asthma"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Autoimmune Disease":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Autoimmune Disease"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Bariatric Surgery":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Bariatric Surgery"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Bleeding Disorder":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Bleeding Disorder"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Cardiac Disease":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Cardiac Disease"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Economic Housing Instability":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Economic Housing Instability"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Gastrointestinal Disease":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Gastrointestinal Disease"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Gestational Diabetes":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Gestational Diabetes"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable HIV":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "HIV"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Hypertension":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Hypertension"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Long Term Anticoagulant Use":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Long Term Anticoagulant Use"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Mental Health Disorder":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Mental Health Disorder"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Multiple Pregnancy":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Multiple Pregnancy"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Neuromuscular":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Neuromuscular Disease"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Obstetrical VTE":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Obstetrical VTE"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Other Preeclampsia":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Other Preeclampsia"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Placenta Previa":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Placenta Previa"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Placental Abruption":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Placental Abruption"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Placental Accreta Spectrum":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Placental Accreta Spectrum"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Preexisting Diabetes":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Preexisting Diabetes"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Previous Cesarean":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Previous Cesarean"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Pulmonary Hypertension":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Pulmonary Hypertension"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Renal Disease":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Renal Disease"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Severe Preeclampsia":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Severe Preeclampsia"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Substance Abuse":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Substance Abuse"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Risk Variable Thyrotoxicosis":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Thyrotoxicosis"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Stratification Encounter":
  "Numerator"
    except "Denominator Exclusion"

define "Risk Variable Anemia":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Anemia"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Delivery Encounters with Expiration":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where TwentyWeeksPlusEncounter.dischargeDisposition in "Patient Expired"

define "Delivery Encounters with Severe Obstetric Complications":
  "Delivery Encounters with Severe Obstetric Complications Diagnosis or Procedure (Excluding Blood Transfusion)"
    union "Delivery Encounters with Expiration"
    union "Delivery Encounters with Blood Transfusion"

define "Denominator Exclusion":
  "Delivery Encounters with COVID and Respiratory Condition or Procedure"

define "Stratum 1":
  //This logic identifies a subset of the numerator population with severe obstetric complications excluding cases where transfusion was the only severe obstetric complication.
  "Stratification Encounter"
    intersect "Delivery Encounters with Severe Obstetric Complications (Excluding Blood Transfusions)"

define "Delivery Encounters with Severe Obstetric Complications (Excluding Blood Transfusions)":
  "Delivery Encounters with Severe Obstetric Complications Diagnosis or Procedure (Excluding Blood Transfusion)"
    union "Delivery Encounters with Expiration"

define "Delivery Encounters with Blood Transfusion":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    with ["Procedure, Performed": "Blood Transfusion"] BloodTransfusion
      such that Global."NormalizeInterval" ( BloodTransfusion.relevantDatetime, BloodTransfusion.relevantPeriod ) starts during day of PCMaternal."HospitalizationWithEDOBTriageObservation" ( TwentyWeeksPlusEncounter )

define "Delivery Encounters with Severe Obstetric Complications Diagnosis or Procedure (Excluding Blood Transfusion)":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Severe Maternal Morbidity Diagnoses"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present on Admission = No or Unable To Determine"
    )
      or exists ( ["Procedure, Performed": "Severe Maternal Morbidity Procedures"] EncounterProcedures
          where Global."NormalizeInterval" ( EncounterProcedures.relevantDatetime, EncounterProcedures.relevantPeriod ) starts during day of PCMaternal."HospitalizationWithEDOBTriageObservation" ( TwentyWeeksPlusEncounter )
      )

define "Numerator":
  "Delivery Encounters with Severe Obstetric Complications"

define "Delivery Encounters with Calculated Gestational Age Greater than or Equal to 20 Weeks":
  PCMaternal."Delivery Encounter with Age Range" DeliveryEncounter
    where PCMaternal."CalculatedGestationalAge" ( DeliveryEncounter ) >= 20

define "Delivery Encounters with Estimated Gestational Age Assessment Greater than or Equal to 20 Weeks":
  PCMaternal."Delivery Encounter with Age Range" DeliveryEncounter
    where PCMaternal."CalculatedGestationalAge" ( DeliveryEncounter ) is null
      and ( PCMaternal."LastEstimatedGestationalAge" ( DeliveryEncounter ) >= 20 weeks )

define "Variable Calculated Gestational Age":
  //This definition establishes a variable of CGA (Calculated Gestational Age).  CGA is a supplemental data element to store the calculated gestational age result from the "CalculatedGestationalAge" function.  The data element enables the capturing and saving of the CGA for data analysis post data receipt. Hospitals do not need to submit any additional data to comply with this definition. 
  PCMaternal."Variable Calculated Gestational Age"

define "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation":
  "Delivery Encounters with Calculated Gestational Age Greater than or Equal to 20 Weeks"
    union "Delivery Encounters with Estimated Gestational Age Assessment Greater than or Equal to 20 Weeks"

define "Risk Variable BMI Greater than or Equal to 40":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "BMI >= 40"
          and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
    )

define "Delivery Encounters with COVID and Respiratory Condition or Procedure":
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" TwentyWeeksPlusEncounter
    where exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "COVID 19 Confirmed"
    )
      and ( exists ( TwentyWeeksPlusEncounter.diagnoses EncounterDiagnoses
            where EncounterDiagnoses.code in "Respiratory Conditions Related to COVID 19"
              or exists ( ["Procedure, Performed": "Respiratory Support Procedures Related to COVID 19"] EncounterProcedures
                  where Global."NormalizeInterval" ( EncounterProcedures.relevantDatetime, EncounterProcedures.relevantPeriod ) starts during day of PCMaternal."HospitalizationWithEDOBTriageObservation" ( TwentyWeeksPlusEncounter )
              )
        )
      )

define "Risk Variable Preterm Birth":
  //CGA = Calculated Gestational Age.  EGA = Estimated Gestational Age.
  ( PCMaternal."Delivery Encounter with Age Range" DeliveryEncounter
      let CGA: PCMaternal."CalculatedGestationalAge" ( DeliveryEncounter ),
      EGA: PCMaternal."LastEstimatedGestationalAge" ( DeliveryEncounter )
      where CGA in Interval[20, 36]
        or ( CGA is null
            and ( EGA >= 20 weeks
                and EGA <= 36 weeks
            )
        )
  )
    union ( PCMaternal."Delivery Encounter with Age Range" DeliveryEncounter
        let CGA: PCMaternal."CalculatedGestationalAge" ( DeliveryEncounter ),
        EGA: PCMaternal."LastEstimatedGestationalAge" ( DeliveryEncounter )
        where CGA is null
          and EGA is null
          and exists ( DeliveryEncounter.diagnoses EncounterDiagnoses
              where EncounterDiagnoses.code in "Preterm Birth"
                and EncounterDiagnoses.presentOnAdmissionIndicator in "Present On Admission = Yes or Exempt"
          )
    )

define "Risk Variable Lab and Physical Exam Results":
  {
  // First physical exams:  Report heart rate as {beats}/min, systolic blood pressure as mm[Hg]
    FirstHeartRate: "FirstPhysicalExamWithEncounterId"(["Physical Exam, Performed": "Heart rate"]),
    FirstSystolicBloodPressure: "FirstPhysicalExamWithEncounterId"(["Physical Exam, Performed": "Systolic blood pressure"]),
  // First lab tests:  Report hematocrit as %, white blood cell count as 10*3/uL
    FirstHematocritLab: "FirstLabTestWithEncounterId"(["Laboratory Test, Performed": "Hematocrit lab test"]),
    FirstWhiteBloodCellCount: "FirstLabTestWithEncounterId"(["Laboratory Test, Performed": "White blood cells count lab test"])
  }

define function "FirstPhysicalExamWithEncounterId"(ExamList List<QDM.PositivePhysicalExamPerformed>):
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" Encounter
    let FirstExam: First(ExamList Exam
  //(first resulted value 24 hours prior to start of encounter and before time of delivery)
        where Global."EarliestOf"(Exam.relevantDatetime, Exam.relevantPeriod)during Interval[start of PCMaternal."HospitalizationWithEDOBTriageObservation"(Encounter)- 1440 minutes, PCMaternal."LastTimeOfDelivery"(Encounter))
        sort by Global."EarliestOf"(relevantDatetime, relevantPeriod)
    )
    return {
      EncounterId: Encounter.id,
      FirstResult: FirstExam.result as Quantity,
      Timing: Global."EarliestOf" ( FirstExam.relevantDatetime, FirstExam.relevantPeriod )
    }

define function "FirstLabTestWithEncounterId"(LabList List<QDM.PositiveLaboratoryTestPerformed>):
  "Delivery Encounters At Greater than or Equal to 20 Weeks Gestation" Encounter
    let FirstLab: First(LabList Lab
  //(first resulted value 24 hours prior to start of encounter and before time of delivery)
        where Lab.resultDatetime during Interval[start of PCMaternal."HospitalizationWithEDOBTriageObservation"(Encounter)- 1440 minutes, PCMaternal."LastTimeOfDelivery"(Encounter))
        sort by resultDatetime
    )
    return {
      EncounterId: Encounter.id,
      FirstResult: FirstLab.result as Quantity,
      Timing: FirstLab.resultDatetime
    }