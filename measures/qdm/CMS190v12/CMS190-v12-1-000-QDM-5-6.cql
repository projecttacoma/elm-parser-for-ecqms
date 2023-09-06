library IntensiveCareUnitVenousThromboembolismProphylaxis version '12.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include TJCOverall version '7.1.000' called TJC
include VTE version '7.2.000' called VTE

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Application of Graduated Compression Stockings": 'urn:oid:2.16.840.1.113762.1.4.1110.66'
valueset "Application of Intermittent Pneumatic Compression Devices": 'urn:oid:2.16.840.1.113762.1.4.1110.65'
valueset "Application of Venous Foot Pumps": 'urn:oid:2.16.840.1.113762.1.4.1110.64'
valueset "Atrial Fibrillation or Flutter": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.202'
valueset "Comfort Measures": 'urn:oid:1.3.6.1.4.1.33895.1.3.0.45'
valueset "Direct Thrombin Inhibitor": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.205'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "General or Neuraxial Anesthesia": 'urn:oid:2.16.840.1.113883.3.666.5.1743'
valueset "General Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.255'
valueset "Glycoprotein IIb IIIa Inhibitors": 'urn:oid:2.16.840.1.113762.1.4.1045.41'
valueset "Graduated compression stockings": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.256'
valueset "Gynecological Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.257'
valueset "Hip Fracture Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.258'
valueset "Hip Replacement Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.259'
valueset "Injectable Factor Xa Inhibitor for VTE Prophylaxis": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.211'
valueset "INR": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.213'
valueset "Intensive Care Unit": 'urn:oid:2.16.840.1.113762.1.4.1029.206'
valueset "Intermittent pneumatic compression devices": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.214'
valueset "Intracranial Neurosurgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.260'
valueset "Intravenous route": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.222'
valueset "Knee Replacement Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.261'
valueset "Low Dose Unfractionated Heparin for VTE Prophylaxis": 'urn:oid:2.16.840.1.113762.1.4.1045.39'
valueset "Low Molecular Weight Heparin for VTE Prophylaxis": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.219'
valueset "Low Risk": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.400'
valueset "Medical Reason For Not Providing Treatment": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.134'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Rivaroxaban for VTE Prophylaxis": 'urn:oid:2.16.840.1.113762.1.4.1110.50'
valueset "Subcutaneous route": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.223'
valueset "Unfractionated Heparin": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.218'
valueset "Urological Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.272'
valueset "Venous foot pumps": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.230'
valueset "Venous Thromboembolism": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.279'
valueset "Warfarin": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.232'

code "Risk for venous thromboembolism": '72136-5' from "LOINC" display 'Risk for venous thromboembolism'

context Patient

define "Denominator":
  "Encounter with ICU Location"

define "Denominator Exclusions":
  "Encounter with ICU Location And Encounter Less Than 2 Days"
    union "Encounter with First ICU Stay with Principal Procedure of SCIP VTE Selected Surgery"
    union "Encounter with Intervention Comfort Measures From Day Of Start of Hospitalization To Day After First ICU Stay"
    union "Encounter with Intervention Comfort Measures on Day of or Day After Procedure"

define "Encounter with ICU Location And Encounter Less Than 2 Days":
  "Encounter with ICU Location" QualifyingEncounterICU
    where Global."LengthInDays" ( QualifyingEncounterICU.relevantPeriod ) < 2

define "Encounter with Low Risk for VTE or Anticoagulant Administered":
  "Low Risk for VTE or Anticoagulant Administered From Day of Start of Hospitalization To Day After First ICU Stay"
    union "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Procedure"

define "Encounter with No VTE Prophylaxis Due to Medical Reason":
  ( "No VTE Prophylaxis Medication Due to Medical Reason From Day Of Start of Hospitalization To Day After First ICU Stay"
      intersect "No Mechanical VTE Prophylaxis Due to Medical Reason From Day Of Start of Hospitalization To Day After First ICU Stay"
  )
    union ( "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Procedure"
        intersect "No Mechanical VTE Prophylaxis Due to Medical Reason on Day of or Day After Procedure"
    )

define "Encounter with No VTE Prophylaxis Due to Patient Refusal":
  "No VTE Prophylaxis Due to Patient Refusal From Day Of Start of Hospitalization To Day After First ICU Stay"
    union "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Procedure"

define "Encounter with Prior or Present Diagnosis of Atrial Fibrillation or Prior Diagnosis of VTE":
  ( "Encounter with ICU Location" QualifyingEncounterICU
      with ["Diagnosis": "Atrial Fibrillation or Flutter"] AtrialFibrillation
        such that AtrialFibrillation.prevalencePeriod starts on or before 
        end of QualifyingEncounterICU.relevantPeriod
  )
    union ( "Encounter with ICU Location" QualifyingEncounterICU
        where exists ( QualifyingEncounterICU.diagnoses QualifyingEncounterDiagnoses
            where QualifyingEncounterDiagnoses.code in "Atrial Fibrillation or Flutter"
        )
    )
    union ( "Encounter with ICU Location" QualifyingEncounterICU
        with ["Diagnosis": "Venous Thromboembolism"] VTEDiagnosis
          such that VTEDiagnosis.prevalencePeriod starts before start of QualifyingEncounterICU.relevantPeriod
    )

define "Encounter with Prior or Present Procedure of Hip or Knee Replacement Surgery":
  "Encounter with ICU Location" QualifyingEncounterICU
    with ( ["Procedure, Performed": "Hip Replacement Surgery"]
      union ["Procedure, Performed": "Knee Replacement Surgery"] ) HipKneeProcedure
      such that Global."NormalizeInterval" ( HipKneeProcedure.relevantDatetime, HipKneeProcedure.relevantPeriod ) starts on or before 
      end of QualifyingEncounterICU.relevantPeriod

define "Intervention Comfort Measures":
  ["Intervention, Order": "Comfort Measures"]
    union ["Intervention, Performed": "Comfort Measures"]

define "Low Risk Indicator For VTE":
  /*The variable "LowRiskDatetime" is to hold VTE Risk Assessment relevant dateTime, INR Laboratory Test result dateTime, and Anticoagulant Medication administration start dateTime.
  */
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
        union ["Medication, Administered": "Glycoprotein IIb IIIa Inhibitors"] ) AnticoagulantMedication
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

define "No Mechanical or Pharmacological VTE Prophylaxis Due to Patient Refusal":
  ( "No VTE Prophylaxis Medication Administered or Ordered"
    union "No Mechanical VTE Prophylaxis Performed or Ordered" ) NoVTEProphylaxis
    where NoVTEProphylaxis.negationRationale in "Patient Refusal"

define "Numerator":
  "Encounter with VTE Prophylaxis Received on Day of or Day After First ICU Stay or Procedure"
    union ( "Encounter with Medication Oral Factor Xa Inhibitor Administered on Day of or Day After First ICU Stay or Procedure"
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

define "Denominator Exceptions":
  "Encounter with First ICU Location Stay Less Than 1 day"

define "Encounter with Intervention Comfort Measures From Day Of Start of Hospitalization To Day After First ICU Stay":
  "Encounter with ICU Location" QualifyingEncounterICU
    with "Intervention Comfort Measures" ComfortMeasures
      such that Coalesce(start of Global."NormalizeInterval"(ComfortMeasures.relevantDatetime, ComfortMeasures.relevantPeriod), ComfortMeasures.authorDatetime)during day of VTE."FromDayOfStartOfHospitalizationToDayAfterFirstICU" ( QualifyingEncounterICU )

define "Encounter with Intervention Comfort Measures on Day of or Day After Procedure":
  from
    "Encounter with ICU Location" QualifyingEncounterICU,
    ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "Intervention Comfort Measures" ComfortMeasures
    where Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of VTE."StartOfFirstICU" ( QualifyingEncounterICU )
      and Coalesce(start of Global."NormalizeInterval"(ComfortMeasures.relevantDatetime, ComfortMeasures.relevantPeriod), ComfortMeasures.authorDatetime)during day of TJC."CalendarDayOfOrDayAfter" ( 
      end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
    return QualifyingEncounterICU

define "Encounter with VTE Prophylaxis Received on Day of or Day After First ICU Stay or Procedure":
  ( "Encounter with ICU Location" QualifyingEncounterICU
      with "Pharmacological or Mechanical VTE Prophylaxis Received" VTEProphylaxis
        such that Global."NormalizeInterval" ( VTEProphylaxis.relevantDatetime, VTEProphylaxis.relevantPeriod ) starts during day of TJC."CalendarDayOfOrDayAfter" ( VTE."StartOfFirstICU" ( QualifyingEncounterICU ) )
  )
    union ( from
        "Encounter with ICU Location" QualifyingEncounterICU,
        ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
        "Pharmacological or Mechanical VTE Prophylaxis Received" VTEProphylaxis
        where Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of VTE."StartOfFirstICU" ( QualifyingEncounterICU )
          and Global."NormalizeInterval" ( VTEProphylaxis.relevantDatetime, VTEProphylaxis.relevantPeriod ) starts during day of TJC."CalendarDayOfOrDayAfter" ( 
          end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
        return QualifyingEncounterICU
    )

define "Low Risk for VTE or Anticoagulant Administered From Day of Start of Hospitalization To Day After First ICU Stay":
  "Encounter with ICU Location" QualifyingEncounterICU
    with "Low Risk Indicator For VTE" LowRiskForVTE
      such that LowRiskForVTE.LowRiskDatetime during day of VTE."FromDayOfStartOfHospitalizationToDayAfterFirstICU" ( QualifyingEncounterICU )

define "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Procedure":
  from
    "Encounter with ICU Location" QualifyingEncounterICU,
    ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "Low Risk Indicator For VTE" LowRiskForVTE
    where Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of VTE."StartOfFirstICU" ( QualifyingEncounterICU )
      and LowRiskForVTE.LowRiskDatetime during day of TJC."CalendarDayOfOrDayAfter" ( 
      end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
    return QualifyingEncounterICU

define "No Mechanical VTE Prophylaxis Due to Medical Reason From Day Of Start of Hospitalization To Day After First ICU Stay":
  "Encounter with ICU Location" QualifyingEncounterICU
    with "No Mechanical VTE Prophylaxis Performed or Ordered" NoMechanicalProphylaxis
      such that NoMechanicalProphylaxis.negationRationale in "Medical Reason For Not Providing Treatment"
        and NoMechanicalProphylaxis.authorDatetime during day of VTE."FromDayOfStartOfHospitalizationToDayAfterFirstICU" ( QualifyingEncounterICU )

define "No VTE Prophylaxis Due to Patient Refusal From Day Of Start of Hospitalization To Day After First ICU Stay":
  "Encounter with ICU Location" QualifyingEncounterICU
    with "No Mechanical or Pharmacological VTE Prophylaxis Due to Patient Refusal" PatientRefusal
      such that PatientRefusal.authorDatetime during day of VTE.FromDayOfStartOfHospitalizationToDayAfterFirstICU ( QualifyingEncounterICU )

define "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Procedure":
  from
    "Encounter with ICU Location" QualifyingEncounterICU,
    ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "No Mechanical or Pharmacological VTE Prophylaxis Due to Patient Refusal" PatientRefusal
    where Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of VTE."StartOfFirstICU" ( QualifyingEncounterICU )
      and PatientRefusal.authorDatetime during day of TJC."CalendarDayOfOrDayAfter" ( 
      end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
    return QualifyingEncounterICU

define "No VTE Prophylaxis Medication Due to Medical Reason From Day Of Start of Hospitalization To Day After First ICU Stay":
  "Encounter with ICU Location" QualifyingEncounterICU
    with "No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedicaion
      such that NoVTEMedicaion.negationRationale in "Medical Reason For Not Providing Treatment"
        and NoVTEMedicaion.authorDatetime during day of VTE."FromDayOfStartOfHospitalizationToDayAfterFirstICU" ( QualifyingEncounterICU )

define "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Procedure":
  from
    "Encounter with ICU Location" QualifyingEncounterICU,
    ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedication
    where NoVTEMedication.negationRationale in "Medical Reason For Not Providing Treatment"
      and Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of VTE."StartOfFirstICU" ( QualifyingEncounterICU )
      and NoVTEMedication.authorDatetime during day of TJC."CalendarDayOfOrDayAfter" ( 
      end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
    return QualifyingEncounterICU

define "Encounter with Medication Oral Factor Xa Inhibitor Administered on Day of or Day After First ICU Stay or Procedure":
  ( "Encounter with ICU Location" QualifyingEncounterICU
      with ["Medication, Administered": "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment"] FactorXaMedication
        such that Global."NormalizeInterval" ( FactorXaMedication.relevantDatetime, FactorXaMedication.relevantPeriod ) starts during day of TJC."CalendarDayOfOrDayAfter" ( VTE."StartOfFirstICU" ( QualifyingEncounterICU ) )
  )
    union ( from
        "Encounter with ICU Location" QualifyingEncounterICU,
        ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
        ["Medication, Administered": "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment"] FactorXaMedication
        where Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of VTE."StartOfFirstICU" ( QualifyingEncounterICU )
          and Global."NormalizeInterval" ( FactorXaMedication.relevantDatetime, FactorXaMedication.relevantPeriod ) starts during day of TJC."CalendarDayOfOrDayAfter" ( 
          end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
        return QualifyingEncounterICU
    )

define "Encounter with First ICU Stay with Principal Procedure of SCIP VTE Selected Surgery":
  "Encounter with ICU Location" QualifyingEncounterICU
    with ( "SCIP VTE Selected Surgery" Procedure
      where Procedure.rank = 1 ) SelectedSCIPProcedure
      such that Global."NormalizeInterval" ( SelectedSCIPProcedure.relevantDatetime, SelectedSCIPProcedure.relevantPeriod ) ends during day of TJC."CalendarDayOfOrDayAfter" ( VTE."StartOfFirstICU" ( QualifyingEncounterICU ) )

define "Encounter with First ICU Location Stay Less Than 1 day":
  "Encounter with ICU Location" QualifyingEncounterICU
    where Global."LengthInDays" ( VTE."FirstICULocationPeriod" ( QualifyingEncounterICU ) ) < 1

define "Initial Population":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions"

define "Encounter with ICU Location":
  VTE."Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
    where exists ( QualifyingEncounter.facilityLocations Location
        where Location.code in "Intensive Care Unit"
          and Location.locationPeriod during QualifyingEncounter.relevantPeriod
    )

define "Pharmacological or Mechanical VTE Prophylaxis Received":
  ( ["Medication, Administered": "Low Dose Unfractionated Heparin for VTE Prophylaxis"] VTEMedication
      where VTEMedication.route in "Subcutaneous route"
  )
    union ["Medication, Administered": "Low Molecular Weight Heparin for VTE Prophylaxis"]
    union ["Medication, Administered": "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
    union ["Medication, Administered": "Warfarin"]
    union ["Medication, Administered": "Rivaroxaban for VTE Prophylaxis"]
    union ["Procedure, Performed": "Application of Intermittent Pneumatic Compression Devices"]
    union ["Procedure, Performed": "Application of Venous Foot Pumps"]
    union ["Procedure, Performed": "Application of Graduated Compression Stockings"]

define "No Mechanical VTE Prophylaxis Performed or Ordered":
  ["Procedure, Not Performed": "Application of Intermittent Pneumatic Compression Devices"]
    union ["Procedure, Not Performed": "Application of Venous Foot Pumps"]
    union ["Procedure, Not Performed": "Application of Graduated Compression Stockings"]
    union ["Device, Not Ordered": "Intermittent pneumatic compression devices"]
    union ["Device, Not Ordered": "Venous foot pumps"]
    union ["Device, Not Ordered": "Graduated compression stockings"]

define "No Mechanical VTE Prophylaxis Due to Medical Reason on Day of or Day After Procedure":
  from
    "Encounter with ICU Location" QualifyingEncounterICU,
    ["Procedure, Performed": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "No Mechanical VTE Prophylaxis Performed or Ordered" NoMechanicalProphylaxis
    where NoMechanicalProphylaxis.negationRationale in "Medical Reason For Not Providing Treatment"
      and Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) ends 1 day after day of VTE."StartOfFirstICU" ( QualifyingEncounterICU )
      and NoMechanicalProphylaxis.authorDatetime during day of TJC."CalendarDayOfOrDayAfter" ( 
      end of Global."NormalizeInterval" ( AnesthesiaProcedure.relevantDatetime, AnesthesiaProcedure.relevantPeriod ) )
    return QualifyingEncounterICU