library DepressionRemissionatTwelveMonths version '12.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Bipolar Disorder": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.128'
valueset "Contact or Office Visit": 'urn:oid:2.16.840.1.113762.1.4.1080.5'
valueset "Dysthymia": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.254'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hospice Care Ambulatory": 'urn:oid:2.16.840.1.113883.3.526.3.1584'
valueset "Hospice Diagnosis": 'urn:oid:2.16.840.1.113883.3.464.1003.1165'
valueset "Hospice Encounter": 'urn:oid:2.16.840.1.113883.3.464.1003.1003'
valueset "Major Depression Including Remission": 'urn:oid:2.16.840.113883.3.67.1.101.3.2444'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Palliative Care Diagnosis": 'urn:oid:2.16.840.1.113883.3.464.1003.1167'
valueset "Palliative Care Encounter": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1090'
valueset "Palliative Care Intervention": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1135'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Personality Disorder Emotionally Labile": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.246'
valueset "Pervasive Developmental Disorder": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1152'
valueset "PHQ 9 and PHQ 9M Tools": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.263'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Schizophrenia or Psychotic Disorder": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1104'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Dead (finding)": '419099009' from "SNOMEDCT" display 'Dead (finding)'
code "Discharge to healthcare facility for hospice care (procedure)": '428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)": '428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'
code "Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)": '71007-9' from "LOINC" display 'Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)'
code "Hospice care [Minimum Data Set]": '45755-6' from "LOINC" display 'Hospice care [Minimum Data Set]'
code "Yes (qualifier value)": '373066001' from "SNOMEDCT" display 'Yes (qualifier value)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Denominator Identification Period":
  Interval[start of "Measurement Period" - 14 months, start of "Measurement Period" - 2 months )

define "Depression Assessments Greater than 9":
  ["Assessment, Performed": "PHQ 9 and PHQ 9M Tools"] DepressionAssessment
    where DepressionAssessment.result > 9

define "Depression Diagnoses":
  ["Diagnosis": "Major Depression Including Remission"]
    union ["Diagnosis": "Dysthymia"]

define "Depression Encounter":
  ["Encounter, Performed": "Contact or Office Visit"] ValidEncounter
    with "Depression Diagnoses" Depression
      such that ValidEncounter.relevantPeriod overlaps Depression.prevalencePeriod
        and ValidEncounter.relevantPeriod ends during "Denominator Identification Period"

define "Has Mental Health Disorder Diagnoses":
  exists ( ( ["Diagnosis": "Bipolar Disorder"]
      union ["Diagnosis": "Personality Disorder Emotionally Labile"]
      union ["Diagnosis": "Schizophrenia or Psychotic Disorder"]
      union ["Diagnosis": "Pervasive Developmental Disorder"] ) MentalHealthDisorderDiagnoses
      where ToDate(start of MentalHealthDisorderDiagnoses.prevalencePeriod)on or before 
      end of "Measure Assessment Period"
  )

define "Initial Population":
  AgeInYearsAt(start of Global."NormalizeInterval"("Index Depression Assessment".relevantDatetime, "Index Depression Assessment".relevantPeriod))>= 12

define "Measure Assessment Period":
  "Index Depression Assessment" FirstIndexAssessment
    let YearAfterIndexAssessment: date from start of Global."NormalizeInterval" ( FirstIndexAssessment.relevantDatetime, FirstIndexAssessment.relevantPeriod ) + 12 months
    return Interval[YearAfterIndexAssessment - 60 days, YearAfterIndexAssessment + 60 days]

define "Numerator":
  Last(["Assessment, Performed": "PHQ 9 and PHQ 9M Tools"] DepressionAssessment
      where ToDate(start of Global."NormalizeInterval"(DepressionAssessment.relevantDatetime, DepressionAssessment.relevantPeriod))during "Measure Assessment Period"
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  ).result < 5

define "Patient Expired":
  exists ( ["Patient Characteristic Expired": "Dead (finding)"] Deceased
      where ToDate(Deceased.expiredDatetime)occurs on or before 
      end of "Measure Assessment Period"
  )

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Stratification 1":
  exists ( ["Patient Characteristic Birthdate": "Birth date"] BirthDate
      with "Index Depression Assessment" IndexAssessment
        such that AgeInYearsAt(date from start of Global."NormalizeInterval"(IndexAssessment.relevantDatetime, IndexAssessment.relevantPeriod))in Interval[12, 17]
  )

define "Stratification 2":
  exists ( ["Patient Characteristic Birthdate": "Birth date"] BirthDate
      with "Index Depression Assessment" IndexAssessment
        such that AgeInYearsAt(date from start of Global."NormalizeInterval"(IndexAssessment.relevantDatetime, IndexAssessment.relevantPeriod))>= 18
  )

define "Has Hospice Services in the Measure Assessment Period":
  exists ( ["Encounter, Performed": "Encounter Inpatient"] InpatientEncounter
      where ( InpatientEncounter.dischargeDisposition ~ "Discharge to home for hospice care (procedure)"
          or InpatientEncounter.dischargeDisposition ~ "Discharge to healthcare facility for hospice care (procedure)"
      )
        and InpatientEncounter.relevantPeriod ends during day of Interval[start of "Denominator Identification Period", 
        end of "Measure Assessment Period"]
  )
    or exists ( ["Encounter, Performed": "Hospice Encounter"] HospiceEncounter
        where HospiceEncounter.relevantPeriod overlaps day of Interval[start of "Denominator Identification Period", 
        end of "Measure Assessment Period"]
    )
    or exists ( ["Assessment, Performed": "Hospice care [Minimum Data Set]"] HospiceAssessment
        where HospiceAssessment.result ~ "Yes (qualifier value)"
          and Global."NormalizeInterval" ( HospiceAssessment.relevantDatetime, HospiceAssessment.relevantPeriod ) overlaps day of Interval[start of "Denominator Identification Period", 
          end of "Measure Assessment Period"]
    )
    or exists ( ["Intervention, Order": "Hospice Care Ambulatory"] HospiceOrder
        where HospiceOrder.authorDatetime during day of Interval[start of "Denominator Identification Period", 
        end of "Measure Assessment Period"]
    )
    or exists ( ["Intervention, Performed": "Hospice Care Ambulatory"] HospicePerformed
        where Global."NormalizeInterval" ( HospicePerformed.relevantDatetime, HospicePerformed.relevantPeriod ) overlaps day of Interval[start of "Denominator Identification Period", 
        end of "Measure Assessment Period"]
    )
    or exists ( ["Diagnosis": "Hospice Diagnosis"] HospiceCareDiagnosis
        where HospiceCareDiagnosis.prevalencePeriod overlaps day of Interval[start of "Denominator Identification Period", 
        end of "Measure Assessment Period"]
    )

define "Index Depression Assessment":
  First("Depression Assessments Greater than 9" DepressionAssessment
      with "Depression Encounter" DepressionEncounter
        such that Global."NormalizeInterval"(DepressionAssessment.relevantDatetime, DepressionAssessment.relevantPeriod)is not null
          and Global."NormalizeInterval"(DepressionAssessment.relevantDatetime, DepressionAssessment.relevantPeriod)during day of Interval[ToDate((start of DepressionEncounter.relevantPeriod)- 7 days), 
          end of DepressionEncounter.relevantPeriod]
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )

define "Has Palliative Care in the Measure Assessment Period":
  exists ( ["Assessment, Performed": "Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)"] PalliativeAssessment
      where Global."NormalizeInterval" ( PalliativeAssessment.relevantDatetime, PalliativeAssessment.relevantPeriod ) overlaps Interval[start of "Denominator Identification Period", 
      end of "Measure Assessment Period"]
  )
    or exists ( ["Diagnosis": "Palliative Care Diagnosis"] PalliativeDiagnosis
        where PalliativeDiagnosis.prevalencePeriod overlaps Interval[start of "Denominator Identification Period", 
        end of "Measure Assessment Period"]
    )
    or exists ( ["Encounter, Performed": "Palliative Care Encounter"] PalliativeEncounter
        where PalliativeEncounter.relevantPeriod overlaps Interval[start of "Denominator Identification Period", 
        end of "Measure Assessment Period"]
    )
    or exists ( ["Intervention, Performed": "Palliative Care Intervention"] PalliativeIntervention
        where Global."NormalizeInterval" ( PalliativeIntervention.relevantDatetime, PalliativeIntervention.relevantPeriod ) overlaps Interval[start of "Denominator Identification Period", 
        end of "Measure Assessment Period"]
    )

define "Denominator Exclusions":
  "Has Hospice Services in the Measure Assessment Period"
    or "Has Palliative Care in the Measure Assessment Period"
    or "Patient Expired"
    or "Has Mental Health Disorder Diagnoses"