library BoneDensityProstateCancerAndrogenDeprivationTherapy version '6.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "AdministrativeGender": 'urn:oid:2.16.840.1.113883.5.1'

valueset "Androgen deprivation therapy for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.48'
valueset "DEXA Dual Energy Xray Absorptiometry, Bone Density for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.38'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Declined": 'urn:oid:2.16.840.1.113883.3.526.3.1582'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Prostate Cancer": 'urn:oid:2.16.840.1.113883.3.526.3.319'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Injection of leuprolide acetate for twelve month period (regime/therapy)": '456381000124102' from "SNOMEDCT" display 'Injection of leuprolide acetate for twelve month period (regime/therapy)'
code "Male": 'M' from "AdministrativeGender" display 'Male'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Androgen Deprivation Therapy for Urology Care Medication Active Start Dates":
  ["Medication, Active": "Androgen deprivation therapy for Urology Care"] ADTActive
    return Global.EarliestOf ( ADTActive.relevantDatetime, ADTActive.relevantPeriod )

define "Androgen Deprivation Therapy for Urology Care Medication Order Start Dates":
  ["Medication, Order": "Androgen deprivation therapy for Urology Care"] ADTOrder
    return Global.EarliestOf ( ADTOrder.authorDatetime, ADTOrder.relevantPeriod )

define "Denominator":
  "Initial Population"

define "Denominator Exception":
  exists ( "No Bone Density Scan Ordered Due to Patient Refusal" )
    or exists ( "No Bone Density Scan Performed Due to Patient Refusal" )

define "Has Baseline DEXA Scan Two Years Prior to the Start of or Less than Three Months After the Start of ADT":
  exists ( ( ["Diagnostic Study, Order": "DEXA Dual Energy Xray Absorptiometry, Bone Density for Urology Care"] DEXAOrdered
        with "Order for 12 Months of ADT During Measurement Period" OrderTwelveMonthsADT
          such that DEXAOrdered.authorDatetime 3 months or less after OrderTwelveMonthsADT.authorDatetime
            or DEXAOrdered.authorDatetime 2 years or less before OrderTwelveMonthsADT.authorDatetime
    )
      union ( ["Diagnostic Study, Performed": "DEXA Dual Energy Xray Absorptiometry, Bone Density for Urology Care"] DEXAPerformed
          with "Order for 12 Months of ADT During Measurement Period" OrderTwelveMonthsADT
            such that Global."NormalizeInterval" ( DEXAPerformed.relevantDatetime, DEXAPerformed.relevantPeriod ) 3 months or less after OrderTwelveMonthsADT.authorDatetime
              or Global."NormalizeInterval" ( DEXAPerformed.relevantDatetime, DEXAPerformed.relevantPeriod ) 2 years or less before OrderTwelveMonthsADT.authorDatetime
      )
  )

define "Has Qualifying Encounter":
  exists ["Encounter, Performed": "Office Visit"] Encounter
    where Encounter.relevantPeriod during "Measurement Period"

define "Numerator":
  "Has Baseline DEXA Scan Two Years Prior to the Start of or Less than Three Months After the Start of ADT"

define "Patient is Male":
  exists ["Patient Characteristic Sex": "Male"]

define "Prostate Cancer Diagnosis":
  ["Diagnosis": "Prostate Cancer"] ProstateCancer
    where ProstateCancer.prevalencePeriod overlaps "Measurement Period"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Initial Population":
  "Patient is Male"
    and "Has Qualifying Encounter"
    and exists "Order for 12 Months of ADT During Measurement Period"

define "Order for 12 Months of ADT During Measurement Period":
  ["Procedure, Order": "Injection of leuprolide acetate for twelve month period (regime/therapy)"] OrderTwelveMonthADT
    with "First ADT During Measurement Period" FirstADTMP
      such that OrderTwelveMonthADT.authorDatetime on or after FirstADTMP
        and OrderTwelveMonthADT.authorDatetime during "Measurement Period"

define "First ADT During Measurement Period":
  First(("Androgen Deprivation Therapy for Urology Care Medication Active Start Dates"
      union "Androgen Deprivation Therapy for Urology Care Medication Order Start Dates")ADTDate
      with "Prostate Cancer Diagnosis" ProstateCancer
        such that ADTDate during ProstateCancer.prevalencePeriod
          and ADTDate during "Measurement Period"
      sort ascending
  )

define "No Bone Density Scan Ordered Due to Patient Refusal":
  ["Diagnostic Study, Not Ordered": "DEXA Dual Energy Xray Absorptiometry, Bone Density for Urology Care"] DEXANotOrdered
    with "Order for 12 Months of ADT During Measurement Period" OrderTwelveMonthsADT
      such that DEXANotOrdered.authorDatetime 3 months or less after OrderTwelveMonthsADT.authorDatetime
        and DEXANotOrdered.negationRationale in "Patient Declined"

define "No Bone Density Scan Performed Due to Patient Refusal":
  ["Diagnostic Study, Not Performed": "DEXA Dual Energy Xray Absorptiometry, Bone Density for Urology Care"] DEXANotPerformed
    with "Order for 12 Months of ADT During Measurement Period" OrderTwelveMonthsADT
      such that DEXANotPerformed.authorDatetime 3 months or less after OrderTwelveMonthsADT.authorDatetime
        and DEXANotPerformed.negationRationale in "Patient Declined"