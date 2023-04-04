library CesareanBirth version '4.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include PCMaternal version '2.21.000' called PCMaternal

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Abnormal Presentation": 'urn:oid:2.16.840.1.113762.1.4.1045.105'
valueset "Cesarean Birth": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.282'
valueset "Delivery of Singleton": 'urn:oid:2.16.840.1.113762.1.4.1045.99'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Placenta Previa": 'urn:oid:2.16.840.1.113762.1.4.1110.37'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "[#] Births.preterm": '11637-6' from "LOINC" display '[#] Births.preterm'
code "[#] Births.term": '11639-2' from "LOINC" display '[#] Births.term'
code "[#] Parity": '11977-6' from "LOINC" display '[#] Parity'
code "[#] Pregnancies": '11996-6' from "LOINC" display '[#] Pregnancies'

context Patient

define "Delivery Encounter with Abnormal Presentation or Placenta Previa":
  "Encounter with Abnormal Presentation"
    union "Encounter with Placenta Previa"

define "Delivery Encounter with Calculated Gestational Age Greater than or Equal to 37 Weeks":
  PCMaternal."Delivery Encounter with Age Range" DeliveryEncounter
    where PCMaternal."CalculatedGestationalAge" ( DeliveryEncounter ) >= 37

define "Delivery Encounter with Cesarean Birth":
  "Singleton Delivery Encounters at 37 Plus Weeks Gravida 1 Parity 0, No Previous Births" QualifyingEncounter
    with ["Procedure, Performed": "Cesarean Birth"] CSection
      such that Global."NormalizeInterval" ( CSection.relevantDatetime, CSection.relevantPeriod ) during PCMaternal."HospitalizationWithEDOBTriageObservation" ( QualifyingEncounter )

define "Delivery Encounter with Estimated Gestational Age Greater than or Equal to 37 Weeks":
  PCMaternal."Delivery Encounter with Age Range" DeliveryEncounter
    where PCMaternal."CalculatedGestationalAge" ( DeliveryEncounter ) is null
      and PCMaternal."LastEstimatedGestationalAge" ( DeliveryEncounter ) >= 37 weeks

define "Delivery Encounter with Gestational Age Greater than or Equal to 37 Weeks":
  "Delivery Encounter with Calculated Gestational Age Greater than or Equal to 37 Weeks"
    union "Delivery Encounter with Estimated Gestational Age Greater than or Equal to 37 Weeks"

define "Denominator":
  "Singleton Delivery Encounters at 37 Plus Weeks Gravida 1 Parity 0, No Previous Births"

define "Denominator Exclusions":
  "Delivery Encounter with Abnormal Presentation or Placenta Previa"

define "Encounter with Abnormal Presentation":
  "Singleton Delivery Encounters at 37 Plus Weeks Gravida 1 Parity 0, No Previous Births" QualifyingEncounter
    let LastAbnormalPresentation: Last(["Assessment, Performed": "Abnormal Presentation"] AbnormalPresentation
        where Global."EarliestOf"(AbnormalPresentation.relevantDatetime, AbnormalPresentation.relevantPeriod)before or on PCMaternal."LastTimeOfDelivery"(QualifyingEncounter)
        sort by Global."EarliestOf"(relevantDatetime, relevantPeriod)
    )
    where exists ( QualifyingEncounter.diagnoses EncounterDiagnosis
        where EncounterDiagnosis.code in "Abnormal Presentation"
    )
      or Global."EarliestOf" ( LastAbnormalPresentation.relevantDatetime, LastAbnormalPresentation.relevantPeriod ) during QualifyingEncounter.relevantPeriod

define "Encounter with Placenta Previa":
  "Singleton Delivery Encounters at 37 Plus Weeks Gravida 1 Parity 0, No Previous Births" QualifyingEncounter
    where exists QualifyingEncounter.diagnoses EncounterDiagnosis
      where EncounterDiagnosis.code in "Placenta Previa"

define "Encounter with Singleton Delivery":
  PCMaternal."Delivery Encounter with Age Range" DeliveryEncounter
    where exists ( DeliveryEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Delivery of Singleton"
    )

define "Initial Population":
  PCMaternal."Delivery Encounter with Age Range"

define "Numerator":
  "Delivery Encounter with Cesarean Birth"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Singleton Delivery Encounters at 37 Plus Weeks Gravida 1 Parity 0, No Previous Births":
  ( "Delivery Encounter with Gestational Age Greater than or Equal to 37 Weeks"
    intersect "Encounter with Singleton Delivery" ) SingletonEncounterGE37Weeks
    where ( ( "LastGravida"(SingletonEncounterGE37Weeks)= 1 )
        or ( "LastParity"(SingletonEncounterGE37Weeks)= 0 )
        or ( ( "LastHistoryPretermBirth"(SingletonEncounterGE37Weeks)= 0 )
            and ( "LastHistoryTermBirth"(SingletonEncounterGE37Weeks)= 0 )
        )
    )

define "Variable Calculated Gestational Age":
  PCMaternal."Variable Calculated Gestational Age"

define function "LastGravida"(Encounter "Encounter, Performed"):
  Last(["Assessment, Performed": "[#] Pregnancies"] Gravida
      where Gravida.relevantDatetime 42 weeks or less before PCMaternal."LastTimeOfDelivery"(Encounter)
        and Gravida.result is not null
      sort by relevantDatetime
  ).result as Integer

define function "LastHistoryPretermBirth"(Encounter "Encounter, Performed"):
  Last(["Assessment, Performed": "[#] Births.preterm"] PretermBirth
      where PretermBirth.relevantDatetime 42 weeks or less before PCMaternal."LastTimeOfDelivery"(Encounter)
        and PretermBirth.result is not null
      sort by relevantDatetime
  ).result as Integer

define function "LastHistoryTermBirth"(Encounter "Encounter, Performed"):
  Last(["Assessment, Performed": "[#] Births.term"] TermBirth
      where TermBirth.relevantDatetime 42 weeks or less before PCMaternal."LastTimeOfDelivery"(Encounter)
        and TermBirth.result is not null
      sort by relevantDatetime
  ).result as Integer

define function "LastParity"(Encounter "Encounter, Performed"):
  Last(["Assessment, Performed": "[#] Parity"] Parity
      where Parity.relevantDatetime 42 weeks or less before PCMaternal."LastTimeOfDelivery"(Encounter)
        and Parity.result is not null
      sort by relevantDatetime
  ).result as Integer