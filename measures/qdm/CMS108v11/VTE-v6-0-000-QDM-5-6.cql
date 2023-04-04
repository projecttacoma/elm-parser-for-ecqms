library VTE version '6.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include TJCOverall version '6.0.000' called TJC

valueset "Obstetrics": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.263' 
valueset "Obstetrics VTE": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.264' 
valueset "Venous Thromboembolism": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.279' 

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Admission without VTE or Obstetrical Conditions":
  Global."Inpatient Encounter" InpatientEncounter
    where not ( exists ( InpatientEncounter.diagnoses EncounterDiagnoses
          where ( EncounterDiagnoses.code in "Obstetrics"
              or EncounterDiagnoses.code in "Venous Thromboembolism"
              or EncounterDiagnoses.code in "Obstetrics VTE"
          )
      )
    )

define "Encounter with Age Range and without VTE Diagnosis or Obstetrical Conditions":
  ( Global."Inpatient Encounter" InpatientEncounter
      where AgeInYearsAt(date from start of InpatientEncounter.relevantPeriod)>= 18
  )
    intersect "Admission without VTE or Obstetrical Conditions"

define function "StartOfFirstICU"(Encounter "Encounter, Performed" ):
  start of "FirstICULocationPeriod"(Encounter)

define function "FirstICULocationPeriod"(Encounter "Encounter, Performed" ):
  Global."FirstInpatientIntensiveCareUnit" ( Encounter ).locationPeriod

define function "FromDayOfStartOfHospitalizationToDayAfterAdmission"(Encounter "Encounter, Performed" ):
  Interval[TJC."TruncateTime" ( start of Global."HospitalizationWithObservation" ( Encounter ) ), TJC."TruncateTime" ( start of Encounter.relevantPeriod + 2 days ) )

define function "FromDayOfStartOfHospitalizationToDayAfterFirstICU"(Encounter "Encounter, Performed" ):
  Interval[TJC."TruncateTime" ( start of Global."HospitalizationWithObservation" ( Encounter ) ), TJC."TruncateTime" ( StartOfFirstICU(Encounter)+ 2 days ) )

