library VenousThromboembolismProphylaxis version '11.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include TJCOverall version '6.0.000' called TJC
include VTE version '6.0.000' called VTE

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Application of Graduated Compression Stockings (GCS)": 'urn:oid:2.16.840.1.113762.1.4.1110.66'
valueset "Application of Intermittent Pneumatic Compression Devices (IPC)": 'urn:oid:2.16.840.1.113762.1.4.1110.65'
valueset "Application of Venous Foot Pumps (VFP)": 'urn:oid:2.16.840.1.113762.1.4.1110.64'
valueset "Atrial Fibrillation/Flutter": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.202'
valueset "Comfort Measures": 'urn:oid:1.3.6.1.4.1.33895.1.3.0.45'
valueset "Direct Thrombin Inhibitor": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.205'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "General or Neuraxial Anesthesia": 'urn:oid:2.16.840.1.113883.3.666.5.1743'
valueset "General Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.255'
valueset "Glycoprotein IIb/IIIa Inhibitors": 'urn:oid:2.16.840.1.113762.1.4.1045.41'
valueset "Graduated compression stockings (GCS)": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.256'
valueset "Gynecological Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.257'
valueset "Hemorrhagic Stroke": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.212'
valueset "Hip Fracture Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.258'
valueset "Hip Replacement Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.259'
valueset "Injectable Factor Xa Inhibitor for VTE Prophylaxis": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.211'
valueset "INR": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.213'
valueset "Intensive Care Unit": 'urn:oid:2.16.840.1.113762.1.4.1029.206'
valueset "Intermittent pneumatic compression devices (IPC)": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.214'
valueset "Intracranial Neurosurgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.260'
valueset "Intravenous route": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.222'
valueset "Ischemic Stroke": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.247'
valueset "Knee Replacement Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.261'
valueset "Low Dose Unfractionated Heparin for VTE Prophylaxis": 'urn:oid:2.16.840.1.113762.1.4.1045.39'
valueset "Low Molecular Weight Heparin for VTE Prophylaxis": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.219'
valueset "Low Risk": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.400'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "Mental Health Diagnoses": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1004'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.134'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Rivaroxaban for VTE Prophylaxis": 'urn:oid:2.16.840.1.113762.1.4.1110.50'
valueset "Subcutaneous route": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.223'
valueset "Unfractionated Heparin": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.218'
valueset "Urological Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.272'
valueset "Venous foot pumps (VFP)": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.230'
valueset "Venous Thromboembolism": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.279'
valueset "Warfarin": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.232'

code "Risk for venous thromboembolism": '72136-5' from "LOINC" display 'Risk for venous thromboembolism'

context Patient

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  "Encounter Less Than 2 Days"
    union "Encounter with ICU Location Stay 1 Day or More"
    union "Encounter with Principal Diagnosis of Mental Disorder or Stroke"
    union "Encounter with Principal Procedure of SCIP VTE Selected Surgery"
    union "Encounter with Intervention Comfort Measures From Day of Start of Hospitalization To Day After Admission"
    union "Encounter with Intervention Comfort Measures on Day of or Day After Procedure"

define "Encounter with Low Risk for VTE or Anticoagulant Administered":
  "Low Risk for VTE or Anticoagulant Administered From Day of Start of Hospitalization To Day After Admission"
    union "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Procedure"

define "Encounter with No VTE Prophylaxis Due to Medical Reason":
  ( "No VTE Prophylaxis Medication Due to Medical Reason From Day of Start of Hospitalization To Day After Admission"
      intersect "No Mechanical VTE Prophylaxis Due to Medical Reason From Day of Start of Hospitalization To Day After Admission"
  )
    union ( "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Procedure"
        intersect "No Mechanical VTE Prophylaxis Due to Medical Reason on Day of or Day After Procedure"
    )

define "Encounter with No VTE Prophylaxis Due to Patient Refusal":
  "No VTE Prophylaxis Due to Patient Refusal From Day of Start of Hospitalization To Day After Admission"
    union "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Procedure"

define "Intervention Comfort Measures":
  ["Intervention, Order": "Comfort Measures"]
    union ["Intervention, Performed": "Comfort Measures"]

define "No Mechanical or Pharmacological VTE Prophylaxis Due to Patient Refusal":
  ( "No VTE Prophylaxis Medication Administered or Ordered"
    union "No Mechanical VTE Prophylaxis Performed or Ordered" ) NoVTEProphylaxis
    where NoVTEProphylaxis.negationRationale in "Patient Refusal"

define "Numerator":
  "Encounter with VTE Prophylaxis Received From Day of Start of Hospitalization To Day After Admission or Procedure"
    union ( "Encounter with Medication Oral Factor Xa Inhibitor Administered on Day of or Day After Admission or Procedure"
        intersect ( "Encounter with Prior or Present Diagnosis of Atrial Fibrillation or Prior Diagnosis of VTE"
            union "Encounter with Prior or Present Procedure of Hip or Knee Replacement Surgery"
        )
    )
    union "Encounter with Low Risk for VTE or Anticoagulant Administered"
    union "Encounter with No VTE Prophylaxis Due to Medical Reason"
    union "Encounter with No VTE Prophylaxis Due to Patient Refusal"

define "SCIP VTE Selected Surgery":
  //'SCIP' stands for Surgical Care Improvement Project
  ["Procedure, Performed": "General Surgery"]
    union ["Procedure, Performed": "Gynecological Surgery"]
    union ["Procedure, Performed": "Hip Fracture Surgery"]
    union ["Procedure, Performed": "Hip Replacement Surgery"]
    union ["Procedure, Performed": "Intracranial Neurosurgery"]
    union ["Procedure, Performed": "Knee Replacement Surgery"]
    union ["Procedure, Performed": "Urological Surgery"]

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Low Risk Indicator For VTE":
  /*The variable "LowRiskDatetime" is to hold VTE Risk Assessment relevant dateTime, INR Laboratory Test result dateTime, and Anticoagulant Medication administration start dateTime.*/
  ( ["Assessment, Performed": "Risk for venous thromboembolism"] VTERiskAssessment
      where VTERiskAssessment.result in "Low Risk"
      return {
        id: VTERiskAssessment.id,
        LowRiskDatetime: Global."EarliestOf" ( VTERiskAssessment.relevantDatetime, VTERiskAssessment.relevantPeriod )
      }
  )
    union ( ["Laboratory Test, Performed": "INR"] INRLabTest
        where INRLabTest.result > 3.0
        return {
          id: INRLabTest.id,
          LowRiskDatetime: INRLabTest.resultDatetime
        }
    )
    union ( ( ( ["Medication, Administered": "Unfractionated Heparin"] UnfractionatedHeparin
          where UnfractionatedHeparin.route in "Intravenous route"
      )
        union ["Medication, Administered": "Direct Thrombin Inhibitor"]
        union ["Medication, Administered": "Glycoprotein IIb/IIIa Inhibitors"] ) AnticoagulantMedication
        return {
          id: AnticoagulantMedication.id,
          LowRiskDatetime: start of Global."NormalizeInterval" ( AnticoagulantMedication.relevantDatetime, AnticoagulantMedication.relevantPeriod )
        }
    )

define "No VTE Prophylaxis Medication Administered or Ordered":
  ["Medication, Not Administered": "Low Dose Unfractionated Heparin for VTE Prophylaxis"]
    union ["Medication, Not Administered": "Low Molecular Weight Heparin for VTE Prophylaxis"]
    union ["Medication, Not Administered": "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
    union ["Medication, Not Administered": "Warfarin"]
    union ["Medication, Not Administered": "Rivaroxaban for VTE Prophylaxis"]
    union ["Medication, Not Ordered": "Low Dose Unfractionated Heparin for VTE Prophylaxis"]
    union ["Medication, Not Ordered": "Low Molecular Weight Heparin for VTE Prophylaxis"]
    union ["Medication, Not Ordered": "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
    union ["Medication, Not Ordered": "Warfarin"]
    union ["Medication, Not Ordered": "Rivaroxaban for VTE Prophylaxis"]

define "Encounter Less Than 2 Days":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    where Global."LengthInDays" ( QualifyingEncounter.relevantPeriod ) < 2

define "Initial Population":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions"

define "Low Risk for VTE or Anticoagulant Administered From Day of Start of Hospitalization To Day After Admission":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    with "Low Risk Indicator For VTE" LowRiskForVTE
      such that LowRiskForVTE.LowRiskDatetime during day of VTE."FromDayOfStartOfHospitalizationToDayAfterAdmission" ( QualifyingEncounter )

define "No VTE Prophylaxis Due to Patient Refusal From Day of Start of Hospitalization To Day After Admission":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    with "No Mechanical or Pharmacological VTE Prophylaxis Due to Patient Refusal" PatientRefusal
      such that PatientRefusal.authorDatetime during day of VTE."FromDayOfStartOfHospitalizationToDayAfterAdmission" ( QualifyingEncounter )

define "No VTE Prophylaxis Medication Due to Medical Reason From Day of Start of Hospitalization To Day After Admission":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    with "No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedication
      such that NoVTEMedication.negationRationale in "Medical Reason"
        and NoVTEMedication.authorDatetime during day of VTE."FromDayOfStartOfHospitalizationToDayAfterAdmission" ( QualifyingEncounter )

define "Encounter with Intervention Comfort Measures on Day of or Day After Procedure":
  from
    VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
    ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "Intervention Comfort Measures" ComfortMeasures
    where Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of start of QualifyingEncounter.relevantPeriod
      and Coalesce(start of Global."NormalizeInterval"(ComfortMeasures.relevantDatetime, ComfortMeasures.relevantPeriod), ComfortMeasures.authorDatetime)during day of TJC."CalendarDayOfOrDayAfter" ( 
      end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
    return QualifyingEncounter

define "Encounter with Medication Oral Factor Xa Inhibitor Administered on Day of or Day After Admission or Procedure":
  ( VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
      with ["Medication, Administered": "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment"] FactorXaMedication
        such that Global."NormalizeInterval" ( FactorXaMedication.relevantDatetime, FactorXaMedication.relevantPeriod ) starts during day of TJC."CalendarDayOfOrDayAfter" ( start of QualifyingEncounter.relevantPeriod )
  )
    union ( from
        VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
        ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
        ["Medication, Administered": "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment"] FactorXaMedication
        where Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of start of QualifyingEncounter.relevantPeriod
          and Global."NormalizeInterval" ( FactorXaMedication.relevantDatetime, FactorXaMedication.relevantPeriod ) starts during day of TJC."CalendarDayOfOrDayAfter" ( 
          end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
        return QualifyingEncounter
    )

define "Encounter with Principal Diagnosis of Mental Disorder or Stroke":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    where exists ( QualifyingEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.rank = 1
          and ( EncounterDiagnoses.code in "Mental Health Diagnoses"
              or EncounterDiagnoses.code in "Hemorrhagic Stroke"
              or EncounterDiagnoses.code in "Ischemic Stroke"
          )
    )

define "Encounter with Principal Procedure of SCIP VTE Selected Surgery":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    with ( "SCIP VTE Selected Surgery" Procedure
      where Procedure.rank = 1 ) SelectedSCIPProcedure
      such that Global."NormalizeInterval" ( SelectedSCIPProcedure.relevantDatetime, SelectedSCIPProcedure.relevantPeriod ) during QualifyingEncounter.relevantPeriod

define "Encounter with Prior or Present Diagnosis of Atrial Fibrillation or Prior Diagnosis of VTE":
  ( VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
      with ["Diagnosis": "Atrial Fibrillation/Flutter"] AtrialFibrillation
        such that AtrialFibrillation.prevalencePeriod starts on or before 
        end of QualifyingEncounter.relevantPeriod
  )
    union ( VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
        where exists ( QualifyingEncounter.diagnoses QualifyingEncounterDiagnoses
            where QualifyingEncounterDiagnoses.code in "Atrial Fibrillation/Flutter"
        )
    )
    union ( VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
        with ["Diagnosis": "Venous Thromboembolism"] VTEDiagnosis
          such that VTEDiagnosis.prevalencePeriod starts before start of QualifyingEncounter.relevantPeriod
    )

define "Encounter with Prior or Present Procedure of Hip or Knee Replacement Surgery":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    with ( ["Procedure, Performed": "Hip Replacement Surgery"]
      union ["Procedure, Performed": "Knee Replacement Surgery"] ) HipKneeProcedure
      such that Global."NormalizeInterval" ( HipKneeProcedure.relevantDatetime, HipKneeProcedure.relevantPeriod ) starts on or before 
      end of QualifyingEncounter.relevantPeriod

define "Encounter with VTE Prophylaxis Received From Day of Start of Hospitalization To Day After Admission or Procedure":
  ( VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
      with "Pharmacological or Mechanical VTE Prophylaxis Received" VTEProphylaxis
        such that Global."NormalizeInterval" ( VTEProphylaxis.relevantDatetime, VTEProphylaxis.relevantPeriod ) starts during day of VTE."FromDayOfStartOfHospitalizationToDayAfterAdmission" ( QualifyingEncounter )
  )
    union ( from
        VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
        ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
        "Pharmacological or Mechanical VTE Prophylaxis Received" VTEProphylaxis
        where Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of start of QualifyingEncounter.relevantPeriod
          and Global."NormalizeInterval" ( VTEProphylaxis.relevantDatetime, VTEProphylaxis.relevantPeriod ) starts during day of TJC."CalendarDayOfOrDayAfter" ( 
          end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
        return QualifyingEncounter
    )

define "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Procedure":
  from
    VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
    ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "Low Risk Indicator For VTE" LowRiskForVTE
    where Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of start of QualifyingEncounter.relevantPeriod
      and LowRiskForVTE.LowRiskDatetime during day of TJC."CalendarDayOfOrDayAfter" ( 
      end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
    return QualifyingEncounter

define "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Procedure":
  from
    VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
    ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedication
    where NoVTEMedication.negationRationale in "Medical Reason"
      and Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of start of QualifyingEncounter.relevantPeriod
      and NoVTEMedication.authorDatetime during day of TJC."CalendarDayOfOrDayAfter" ( 
      end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
    return QualifyingEncounter

define "Pharmacological or Mechanical VTE Prophylaxis Received":
  ( ["Medication, Administered": "Low Dose Unfractionated Heparin for VTE Prophylaxis"] VTEMedication
      where VTEMedication.route in "Subcutaneous route"
  )
    union ["Medication, Administered": "Low Molecular Weight Heparin for VTE Prophylaxis"]
    union ["Medication, Administered": "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
    union ["Medication, Administered": "Warfarin"]
    union ["Medication, Administered": "Rivaroxaban for VTE Prophylaxis"]
    union ["Procedure, Performed": "Application of Intermittent Pneumatic Compression Devices (IPC)"]
    union ["Procedure, Performed": "Application of Venous Foot Pumps (VFP)"]
    union ["Procedure, Performed": "Application of Graduated Compression Stockings (GCS)"]

define "Encounter with Intervention Comfort Measures From Day of Start of Hospitalization To Day After Admission":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    with "Intervention Comfort Measures" ComfortMeasures
      such that Coalesce(start of Global."NormalizeInterval"(ComfortMeasures.relevantDatetime, ComfortMeasures.relevantPeriod), ComfortMeasures.authorDatetime)during day of VTE."FromDayOfStartOfHospitalizationToDayAfterAdmission" ( QualifyingEncounter )

define "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Procedure":
  from
    VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
    ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "No Mechanical or Pharmacological VTE Prophylaxis Due to Patient Refusal" PatientRefusal
    where Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of start of QualifyingEncounter.relevantPeriod
      and PatientRefusal.authorDatetime during day of TJC."CalendarDayOfOrDayAfter" ( 
      end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
    return QualifyingEncounter

define "Encounter with ICU Location Stay 1 Day or More":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    where exists ( QualifyingEncounter.facilityLocations Location
        where Location.code in "Intensive Care Unit"
          and Global."LengthInDays" ( Location.locationPeriod ) >= 1
          and Location.locationPeriod starts during Interval[start of QualifyingEncounter.relevantPeriod, TJC."TruncateTime" ( start of QualifyingEncounter.relevantPeriod + 2 days ) )
    )

define "No Mechanical VTE Prophylaxis Performed or Ordered":
  ["Procedure, Not Performed": "Application of Intermittent Pneumatic Compression Devices (IPC)"]
    union ["Procedure, Not Performed": "Application of Venous Foot Pumps (VFP)"]
    union ["Procedure, Not Performed": "Application of Graduated Compression Stockings (GCS)"]
    union ["Device, Not Ordered": "Intermittent pneumatic compression devices (IPC)"]
    union ["Device, Not Ordered": "Venous foot pumps (VFP)"]
    union ["Device, Not Ordered": "Graduated compression stockings (GCS)"]

define "No Mechanical VTE Prophylaxis Due to Medical Reason on Day of or Day After Procedure":
  from
    VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
    ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "No Mechanical VTE Prophylaxis Performed or Ordered" NoVTEDevice
    where NoVTEDevice.negationRationale in "Medical Reason"
      and Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of start of QualifyingEncounter.relevantPeriod
      and NoVTEDevice.authorDatetime during day of TJC."CalendarDayOfOrDayAfter" ( 
      end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
    return QualifyingEncounter

define "No Mechanical VTE Prophylaxis Due to Medical Reason From Day of Start of Hospitalization To Day After Admission":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    with "No Mechanical VTE Prophylaxis Performed or Ordered" NoVTEDevice
      such that NoVTEDevice.negationRationale in "Medical Reason"
        and NoVTEDevice.authorDatetime during day of VTE."FromDayOfStartOfHospitalizationToDayAfterAdmission" ( QualifyingEncounter )