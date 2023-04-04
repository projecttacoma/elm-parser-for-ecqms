library BreastCancerScreening version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include AdultOutpatientEncounters version '3.0.000' called AdultOutpatientEncounters
include Hospice version '4.0.000' called Hospice
include PalliativeCareExclusionECQM version '2.0.000' called PalliativeCare
include AdvancedIllnessandFrailtyExclusionECQM version '7.0.000' called AIFrailLTCF

codesystem "AdministrativeGender": 'urn:oid:2.16.840.1.113883.5.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Bilateral Mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1005'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "History of bilateral mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1068'
valueset "Mammography": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1018'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Status Post Left Mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1069'
valueset "Status Post Right Mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1070'
valueset "Unilateral Mastectomy Left": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1133'
valueset "Unilateral Mastectomy Right": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1134'
valueset "Unilateral Mastectomy, Unspecified Laterality": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1071'

code "Female": 'F' from "AdministrativeGender" display 'Female'
code "Left (qualifier value)": '7771000' from "SNOMEDCT" display 'Left (qualifier value)'
code "Right (qualifier value)": '24028007' from "SNOMEDCT" display 'Right (qualifier value)'

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

define "Bilateral Mastectomy Diagnosis":
  ["Diagnosis": "History of bilateral mastectomy"] BilateralMastectomyHistory
    where BilateralMastectomyHistory.prevalencePeriod starts on or before 
    end of "Measurement Period"

define "Bilateral Mastectomy Procedure":
  ["Procedure, Performed": "Bilateral Mastectomy"] BilateralMastectomyPerformed
    where Global."NormalizeInterval" ( BilateralMastectomyPerformed.relevantDatetime, BilateralMastectomyPerformed.relevantPeriod ) ends on or before 
    end of "Measurement Period"

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or ( ( exists ( "Right Mastectomy Diagnosis" )
          or exists ( "Right Mastectomy Procedure" )
      )
        and ( exists ( "Left Mastectomy Diagnosis" )
            or exists ( "Left Mastectomy Procedure" )
        )
    )
    or exists "Bilateral Mastectomy Diagnosis"
    or exists "Bilateral Mastectomy Procedure"
    or AIFrailLTCF."Is Age 66 or Older with Advanced Illness and Frailty"
    or AIFrailLTCF."Is Age 66 or Older Living Long Term in a Nursing Home"
    or PalliativeCare."Palliative Care in the Measurement Period"

define "Left Mastectomy Diagnosis":
  ( ["Diagnosis": "Status Post Left Mastectomy"]
    union ( ["Diagnosis": "Unilateral Mastectomy, Unspecified Laterality"] UnilateralMastectomyDiagnosis
        where UnilateralMastectomyDiagnosis.anatomicalLocationSite ~ "Left (qualifier value)"
    ) ) LeftMastectomy
    where LeftMastectomy.prevalencePeriod starts on or before 
    end of "Measurement Period"

define "Left Mastectomy Procedure":
  ["Procedure, Performed": "Unilateral Mastectomy Left"] UnilateralMastectomyLeftPerformed
    where Global."NormalizeInterval" ( UnilateralMastectomyLeftPerformed.relevantDatetime, UnilateralMastectomyLeftPerformed.relevantPeriod ) ends on or before 
    end of "Measurement Period"

define "Right Mastectomy Diagnosis":
  ( ["Diagnosis": "Status Post Right Mastectomy"] RightMastectomyProcedure
    union ( ["Diagnosis": "Unilateral Mastectomy, Unspecified Laterality"] UnilateralMastectomyDiagnosis
        where UnilateralMastectomyDiagnosis.anatomicalLocationSite ~ "Right (qualifier value)"
    ) ) RightMastectomy
    where RightMastectomy.prevalencePeriod starts on or before 
    end of "Measurement Period"

define "Right Mastectomy Procedure":
  ["Procedure, Performed": "Unilateral Mastectomy Right"] UnilateralMastectomyRightPerformed
    where Global."NormalizeInterval" ( UnilateralMastectomyRightPerformed.relevantDatetime, UnilateralMastectomyRightPerformed.relevantPeriod ) ends on or before 
    end of "Measurement Period"

define "Initial Population":
  exists ( ["Patient Characteristic Sex": "Female"] )
    and AgeInYearsAt(date from 
      end of "Measurement Period"
    )in Interval[52, 74]
    and exists AdultOutpatientEncounters."Qualifying Encounters"

define "Numerator":
  exists ( ["Diagnostic Study, Performed": "Mammography"] Mammogram
      where ( Global."NormalizeInterval" ( Mammogram.relevantDatetime, Mammogram.relevantPeriod ) ends during day of Interval["October 1 Two Years Prior to the Measurement Period", 
        end of "Measurement Period"]
      )
  )

define "October 1 Two Years Prior to the Measurement Period":
  DateTime((year from start of "Measurement Period" - 2), 10, 1, 0, 0, 0, 0, 0)