library PCMaternal version '3.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1' 

valueset "Delivery Procedures": 'urn:oid:2.16.840.1.113762.1.4.1045.59' 
valueset "ED Visit and OB Triage": 'urn:oid:2.16.840.1.113762.1.4.1029.369' 
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307' 
valueset "Estimated Gestational Age at Delivery": 'urn:oid:2.16.840.1.113762.1.4.1045.26' 
valueset "Observation Services": 'urn:oid:2.16.840.1.113762.1.4.1111.143' 

code "Date and time of obstetric delivery": '93857-1' from "LOINC" display 'Date and time of obstetric delivery'
code "Delivery date Estimated": '11778-8' from "LOINC" display 'Delivery date Estimated'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Delivery Encounter with Age Range":
  "Encounter with Age Range" EncounterWithAge
    with ["Procedure, Performed": "Delivery Procedures"] DeliveryProcedure
      such that Global."NormalizeInterval" ( DeliveryProcedure.relevantDatetime, DeliveryProcedure.relevantPeriod ) starts during day of "HospitalizationWithEDOBTriageObservation"(EncounterWithAge)

define "Encounter with Age Range":
  ["Encounter, Performed": "Encounter Inpatient"] EncounterInpatient
    where AgeInYearsAt(date from start of EncounterInpatient.relevantPeriod)>= 8
      and AgeInYearsAt(date from start of EncounterInpatient.relevantPeriod)< 65
      and EncounterInpatient.relevantPeriod ends during day of "Measurement Period"

define "Variable Calculated Gestational Age":
  //This definition establishes a variable of CGA (Calculated Gestational Age).  CGA is a supplemental data element to store the calculated gestational age result from the "CalculatedGestationalAge" function.  The data element enables the capturing and saving of the CGA for data analysis post data receipt. Hospitals do not need to submit any additional data to comply with this definition.  
  "Delivery Encounter with Age Range" QualifyingEncounter
    let CGA: "CalculatedGestationalAge"(QualifyingEncounter)
    return { QualifyingEncounter, CGA }

define function "LastTimeOfDelivery"(Encounter "Encounter, Performed" ):
  Last(["Assessment, Performed": "Date and time of obstetric delivery"] TimeOfDelivery
      where Global."EarliestOf"(TimeOfDelivery.relevantDatetime, TimeOfDelivery.relevantPeriod)during "HospitalizationWithEDOBTriageObservation"(Encounter)
        and TimeOfDelivery.result as DateTime during "HospitalizationWithEDOBTriageObservation"(Encounter)
      sort by Global."EarliestOf"(relevantDatetime, relevantPeriod)
  ).result as DateTime

define function "LastEstimatedGestationalAge"(Encounter "Encounter, Performed" ):
  Last(["Assessment, Performed": "Estimated Gestational Age at Delivery"] EstimatedGestationalAge
      where Global."EarliestOf"(EstimatedGestationalAge.relevantDatetime, EstimatedGestationalAge.relevantPeriod)24 hours or less before or on "LastTimeOfDelivery"(Encounter)
        and EstimatedGestationalAge.result is not null
      sort by Global."EarliestOf"(relevantDatetime, relevantPeriod)
  ).result as Quantity

define function "HospitalizationWithEDOBTriageObservation"(Encounter "Encounter, Performed" ):
  //HospitalizationWithEDOBTriageObservation returns the total interval from the start of any immediately prior emergency department visit or OB Triage visit through the observation visit to the discharge of the given encounter.
  Encounter Visit
    let ObsVisit: Last(["Encounter, Performed": "Observation Services"] LastObs
        where LastObs.relevantPeriod ends 1 hour or less on or before start of Visit.relevantPeriod
        sort by 
        end of relevantPeriod
    ),
    VisitStart: Coalesce(start of ObsVisit.relevantPeriod, start of Visit.relevantPeriod),
    EDOBTriageVisit: Last(["Encounter, Performed": "ED Visit and OB Triage"] LastEDOBTriage
        where LastEDOBTriage.relevantPeriod ends 1 hour or less on or before VisitStart
        sort by 
        end of relevantPeriod
    )
    return Interval[Coalesce(start of EDOBTriageVisit.relevantPeriod, VisitStart), 
    end of Visit.relevantPeriod]

define function "CalculatedGestationalAge"(Encounter "Encounter, Performed" ):
  // Age = (280-(Estimated Delivery Date minus Reference Date/Delivery Date))/7
  ( 280 - ( difference in days between "LastTimeOfDelivery"(Encounter)and "LastEstimatedDeliveryDate"(Encounter)) ) div 7

define function "LastEstimatedDeliveryDate"(Encounter "Encounter, Performed" ):
  //This function identifies the last time the Estimated Delivery Date was assessed 42 weeks or less prior to or on delivery and stores the result of that assessment.  
  Last(["Assessment, Performed": "Delivery date Estimated"] EstimatedDateOfDelivery
      where Global."EarliestOf"(EstimatedDateOfDelivery.relevantDatetime, EstimatedDateOfDelivery.relevantPeriod)42 weeks or less before or on "LastTimeOfDelivery"(Encounter)
        and EstimatedDateOfDelivery.result is not null
      sort by Global."EarliestOf"(relevantDatetime, relevantPeriod)
  ).result as DateTime

