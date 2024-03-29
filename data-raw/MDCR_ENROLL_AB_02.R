# Total Medicare Enrollment:  Total, Original Medicare, and Medicare Advantage and Other Health Plan Enrollment
library(magrittr)

# Get a temporary directory to extract zip files to.
tmpdir <- tempdir()

# unzip the files
unzip("program_statistics/2013_enrollment/Total_Med_Enroll_XLSX.zip",      junkpaths = TRUE, exdir = paste0(tmpdir, "/2013"))
unzip("program_statistics/2014_enrollment/2014_Total_Med_Enroll_XLSX.zip", junkpaths = TRUE, exdir = paste0(tmpdir, "/2014"))
unzip("program_statistics/2015_enrollment/2015_Total_Med_Enroll_XLSX.zip", junkpaths = TRUE, exdir = paste0(tmpdir, "/2015"))
unzip("program_statistics/2016_enrollment/2016_Total_Med_Enroll_XLSX.zip", junkpaths = TRUE, exdir = paste0(tmpdir, "/2016"))
unzip("program_statistics/2017_enrollment/2017_Total_Med_Enroll_XLSX.zip", junkpaths = TRUE, exdir = paste0(tmpdir, "/2017"))

MDCR_ENROLL_AB_02 <-
  lapply(
         c(paste0(tmpdir, "/2013/CPS_MDCR_ENROLL_AB_2.xlsx"),
           paste0(tmpdir, "/2014/CPS_MDCR_ENROLL_AB_2.xlsx"),
           paste0(tmpdir, "/2015/CPS_MDCR_ENROLL_AB_2.xlsx"),
           paste0(tmpdir, "/2016/CPS_MDCR_ENROLL_AB_2.xlsx"),
           paste0(tmpdir, "/2017/CPS_MDCR_ENROLL_AB_2.xlsx"))
         ,
         readxl::read_excel,
         skip = 3)

MDCR_ENROLL_AB_02[[1]]$Year <- 2013L
MDCR_ENROLL_AB_02[[2]]$Year <- 2014L
MDCR_ENROLL_AB_02[[3]]$Year <- 2015L
MDCR_ENROLL_AB_02[[4]]$Year <- 2016L
MDCR_ENROLL_AB_02[[5]]$Year <- 2017L

MDCR_ENROLL_AB_02 %<>%
  dplyr::bind_rows(.) %>%
  dplyr::filter(`Area of Residence` != "BLANK") %>%
  dplyr::mutate(`Area of Residence` = gsub("\\d$", "", `Area of Residence`)) %>%
  dplyr::filter(`Area of Residence` %in% c("United States", state.name)) %>%
  dplyr::distinct(.) %>%
  dplyr::rename(`State Population` = `State Population 1`)

MDCR_ENROLL_AB_02 %>% dplyr::filter(`Area of Residence` == "United States")

lapply(MDCR_ENROLL_AB_02, tools::showNonASCII)

suppressWarnings({
                   MDCR_ENROLL_AB_02$`Total Enrollment Non-Core-Based Statistical Area` %<>% as.integer(.)
                   MDCR_ENROLL_AB_02$`Total Enrollment Micropolitan Residence` %<>% as.integer(.)
                 })

cat("# Auto Generated. Do not edit by hand",
    "#' Total Medicare Enrollment:  Total, Original Medicare, Medicare Advantage and Other Health Plan Enrollment, and Resident Population, by Area of Residence",
    "#'",
    "#' Total Medicare Enrollment:  Total, Original Medicare, Medicare Advantage and Other Health Plan Enrollment, and Resident Population, by Area of Residence",
    "#'",
    "#' Counts between 1 and 10 have been suppressed because of CMS rules to protect the privacy of beneficiaries.",
    "#'",
    "#' United States Totals Excludes territories, possessions, foreign countries, and unknown.",
    "#'",
    "#' Total United States and state population estimates are available on the U.S. Census Bureau's website:  http://www.census.gov/popest/",
    "#'",
    "#' NOTES:  The enrollment counts are determined  using a person-year methodology.  Numbers and percentages may not add to totals because of",
    "#' rounding.  For definitions of \"Metropolitan\", \"Micropolitan\", and \"Non-Core-Based Statistical Area\", refer to CPS Glossary.",
    "#'",
    "#' @source  Centers for Medicare & Medicaid Services, Office of Enterprise Data and Analytics, Chronic Conditions Data Warehouse; United States Census Bureau.",
    "#'",
    "\"MDCR_ENROLL_AB_02\"",
    sep = "\n",
    file = "../R/MDCR_ENROLL_AB_02.R")

MDCR_ENROLL_AB_02 %<>% as.data.frame
save(MDCR_ENROLL_AB_02, file = "../data/MDCR_ENROLL_AB_02.rda")
