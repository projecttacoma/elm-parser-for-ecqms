# ELM Parser

## Getting started

This ELM Parser has been developed to extract the required data elements and attributes for a given set of measure specifications.  This parser can currently be used with 'bundles' of measures using the following data models QDM R5.6:

 1. QDM R5.6 (qdm)
 2. FHIR R4.0.1 (fhir)
 3. QI CORE R4.1.1 (qicore)

The inputs to this parser are made in the measures/{bundle} folder.  The directory structure for the QDM based measures is a single folder for each eCQM.  That folder will contain the root ELM file as well as any dependent ELM files.

The directory structure for the FHIR/QICore based measures is to place the root ELM files directly in the measures/{bundle} folder.  All of the shared dependent libraries are placed in the measures/{bundle}/supporting folder.

Running the parse_elm command will output CSV files for each measure (as well as a combined file for all measure) with the Data Elements/Valueset and Attributes used by the specific measures.

    ruby parse_elm.rb --bundle qdm

After running the parser_elm command, the summary command can be used to create a CSV file that contains the listing of QI Core profiles in use, the mapped UC Core Profiles, the attributes in use and the measure counts for each profile.

	ruby summary.rb --bundle qdm
 
