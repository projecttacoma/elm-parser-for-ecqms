library HIVSTITesting version '1.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Chlamydia Screening": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1052'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Face-to-Face Interaction": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1048'
valueset "Gonorrhea Screening": 'urn:oid:2.16.840.1.113762.1.4.1258.1'
valueset "HIV": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Syphilis Tests": 'urn:oid:2.16.840.1.113762.1.4.1166.117'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "Unlisted preventive medicine service": '99429' from "CPT" display 'Unlisted preventive medicine service'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")>= 13
    and "Has Qualifying Encounter During Measurement Period"
    and "Has HIV Diagnosis Before End of Measurement Period"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Numerator":
  "Has Chlamydia Testing"
    and "Has Gonorrhea Testing"
    and "Has Syphilis Testing"

define "Has HIV Diagnosis Before End of Measurement Period":
  exists ["Diagnosis": "HIV"] HIVDx
    where HIVDx.prevalencePeriod starts on or before day of 
    end of "Measurement Period"

define "Has Qualifying Encounter During Measurement Period":
  exists ( ( ["Encounter, Performed": "Office Visit"]
      union ["Encounter, Performed": "Outpatient Consultation"]
      union ["Encounter, Performed": "Annual Wellness Visit"]
      union ["Encounter, Performed": "Face-to-Face Interaction"]
      union ["Encounter, Performed": "Home Healthcare Services"]
      union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
      union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
      union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"]
      union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
      union ["Encounter, Performed": "Telephone Visits"]
      union ["Encounter, Performed": "Unlisted preventive medicine service"] ) QualifyingEncounter
      where QualifyingEncounter.relevantPeriod during day of "Measurement Period"
  )

define "Has Chlamydia Testing":
  exists ["Laboratory Test, Performed": "Chlamydia Screening"] ChlamydiaTest
    where ChlamydiaTest.result is not null
      and Global."LatestOf" ( ChlamydiaTest.relevantDatetime, ChlamydiaTest.relevantPeriod ) during day of "Measurement Period"

define "Has Gonorrhea Testing":
  exists ["Laboratory Test, Performed": "Gonorrhea Screening"] GonorrheaTest
    where GonorrheaTest.result is not null
      and Global."LatestOf" ( GonorrheaTest.relevantDatetime, GonorrheaTest.relevantPeriod ) during day of "Measurement Period"

define "Has Syphilis Testing":
  exists ["Laboratory Test, Performed": "Syphilis Tests"] SyphilisTest
    where SyphilisTest.result is not null
      and Global."LatestOf" ( SyphilisTest.relevantDatetime, SyphilisTest.relevantPeriod ) during day of "Measurement Period"