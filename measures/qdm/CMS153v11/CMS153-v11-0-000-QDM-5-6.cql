library ChlamydiaScreeninginWomen version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice

codesystem "AdministrativeGender": 'urn:oid:2.16.840.1.113883.5.1'
codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Chlamydia Screening": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1052'
valueset "Complications of Pregnancy, Childbirth and the Puerperium": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1012'
valueset "Contraceptive Medications": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1080'
valueset "Diagnoses Used to Indicate Sexual Activity": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1018'
valueset "Diagnostic Studies During Pregnancy": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1008'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "HIV": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Isotretinoin": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1143'
valueset "Lab Tests During Pregnancy": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1007'
valueset "Lab Tests for Sexually Transmitted Infections": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1051'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Pap Test": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1017'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pregnancy Test": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1011'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Procedures Used to Indicate Sexual Activity": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1017'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "XRay Study": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1034'

code "Female": 'F' from "AdministrativeGender" display 'Female'
code "Have you ever had vaginal intercourse [PhenX]": '64728-9' from "LOINC" display 'Have you ever had vaginal intercourse [PhenX]'
code "Yes (qualifier value)": '373066001' from "SNOMEDCT" display 'Yes (qualifier value)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Has Diagnoses Identifying Sexual Activity":
  exists ( ( ["Diagnosis": "Diagnoses Used to Indicate Sexual Activity"]
      union ["Diagnosis": "HIV"]
      union ["Diagnosis": "Complications of Pregnancy, Childbirth and the Puerperium"] ) SexualActivityDiagnosis
      where SexualActivityDiagnosis.prevalencePeriod overlaps "Measurement Period"
  )

define "Has Active Contraceptive Medications":
  exists ( ["Medication, Active": "Contraceptive Medications"] ActiveContraceptives
      where ActiveContraceptives.relevantPeriod overlaps "Measurement Period"
  )

define "Denominator":
  "Initial Population"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Numerator":
  exists ( ["Laboratory Test, Performed": "Chlamydia Screening"] ChlamydiaTest
      where Global."LatestOf" ( ChlamydiaTest.relevantDatetime, ChlamydiaTest.relevantPeriod ) during day of "Measurement Period"
        and ChlamydiaTest.result is not null
  )

define "Has Diagnostic Studies Identifying Sexual Activity":
  exists ( ["Diagnostic Study, Order": "Diagnostic Studies During Pregnancy"] SexualActivityDiagnostics
      where SexualActivityDiagnostics.authorDatetime during day of "Measurement Period"
  )

define "Has Laboratory Tests Identifying Sexual Activity":
  exists ( ["Laboratory Test, Order": "Pregnancy Test"] PregnancyTest
      where PregnancyTest.authorDatetime during day of "Measurement Period"
  )
    or "Has Laboratory Tests Identifying Sexual Activity But Not Pregnancy"

define "Has Laboratory Tests Identifying Sexual Activity But Not Pregnancy":
  exists ( ( ["Laboratory Test, Order": "Pap Test"]
      union ["Laboratory Test, Order": "Lab Tests During Pregnancy"]
      union ["Laboratory Test, Order": "Lab Tests for Sexually Transmitted Infections"] ) LabOrders
      where LabOrders.authorDatetime during day of "Measurement Period"
  )

define "Has Ordered Contraceptive Medications":
  exists ( ["Medication, Order": "Contraceptive Medications"] OrderedContraceptives
      where OrderedContraceptives.authorDatetime during day of "Measurement Period"
  )

define "Has Procedures Identifying Sexual Activity":
  exists ( ["Procedure, Performed": "Procedures Used to Indicate Sexual Activity"] ProceduresForSexualActivity
      where Global."NormalizeInterval" ( ProceduresForSexualActivity.relevantDatetime, ProceduresForSexualActivity.relevantPeriod ) during day of "Measurement Period"
  )

define "Has Pregnancy Test Exclusion":
  exists ( ( ["Laboratory Test, Order": "Pregnancy Test"] PregnancyTest
        with ["Diagnostic Study, Order": "XRay Study"] XrayOrder
          such that XrayOrder.authorDatetime occurs 7 days or less on or after day of PregnancyTest.authorDatetime
        where PregnancyTest.authorDatetime during "Measurement Period"
    )
      union ( ["Laboratory Test, Order": "Pregnancy Test"] PregnancyTestOrder
          with ["Medication, Order": "Isotretinoin"] AccutaneOrder
            such that AccutaneOrder.authorDatetime occurs 7 days or less on or after day of PregnancyTestOrder.authorDatetime
          where PregnancyTestOrder.authorDatetime during "Measurement Period"
      )
  )

define "Initial Population":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )in Interval[16, 24]
    and exists ( ["Patient Characteristic Sex": "Female"] )
    and exists ( "Qualifying Encounters" )
    and ( ( "Has Assessments Identifying Sexual Activity" )
        or ( "Has Diagnoses Identifying Sexual Activity" )
        or ( "Has Active Contraceptive Medications" )
        or ( "Has Ordered Contraceptive Medications" )
        or ( "Has Laboratory Tests Identifying Sexual Activity" )
        or ( "Has Diagnostic Studies Identifying Sexual Activity" )
        or ( "Has Procedures Identifying Sexual Activity" )
    )

define "Stratification 1":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )in Interval[16, 20]

define "Stratification 2":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )in Interval[21, 24]

define "Qualifying Encounters":
  ( ( ["Encounter, Performed": "Office Visit"]
      union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
      union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
      union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"]
      union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
      union ["Encounter, Performed": "Home Healthcare Services"]
      union ["Encounter, Performed": "Telephone Visits"]
      union ["Encounter, Performed": "Online Assessments"] ) ValidEncounters
      where ValidEncounters.relevantPeriod during day of "Measurement Period"
  )

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or ( ( "Has Pregnancy Test Exclusion" )
        and not ( "Has Assessments Identifying Sexual Activity" )
        and not ( "Has Diagnoses Identifying Sexual Activity" )
        and not ( "Has Active Contraceptive Medications" )
        and not ( "Has Ordered Contraceptive Medications" )
        and not ( "Has Laboratory Tests Identifying Sexual Activity But Not Pregnancy" )
        and not ( "Has Diagnostic Studies Identifying Sexual Activity" )
        and not ( "Has Procedures Identifying Sexual Activity" )
    )

define "Has Assessments Identifying Sexual Activity":
  exists ( ["Assessment, Performed": "Have you ever had vaginal intercourse [PhenX]"] SexualActivityAssessment
      where SexualActivityAssessment.result ~ "Yes (qualifier value)"
        and Global."NormalizeInterval" ( SexualActivityAssessment.relevantDatetime, SexualActivityAssessment.relevantPeriod ) on or before 
        end of "Measurement Period"
  )