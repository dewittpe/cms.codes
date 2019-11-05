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

MDCR_ENROLL_AB_06 <-
  lapply(
         c(paste0(tmpdir, "/2013/CPS_MDCR_ENROLL_AB_6.xlsx"),
           paste0(tmpdir, "/2014/CPS_MDCR_ENROLL_AB_6.xlsx"),
           paste0(tmpdir, "/2015/CPS_MDCR_ENROLL_AB_6.xlsx"),
           paste0(tmpdir, "/2016/CPS_MDCR_ENROLL_AB_6.xlsx"),
           paste0(tmpdir, "/2017/CPS_MDCR_ENROLL_AB_6.xlsx"))
         ,
         readxl::read_excel,
         skip = 3,
         col_type = "text"
  )

MDCR_ENROLL_AB_06[[1]]$Year <- 2013L
MDCR_ENROLL_AB_06[[2]]$Year <- 2014L
MDCR_ENROLL_AB_06[[3]]$Year <- 2015L
MDCR_ENROLL_AB_06[[4]]$Year <- 2016L
MDCR_ENROLL_AB_06[[5]]$Year <- 2017L

MDCR_ENROLL_AB_06 %<>%
  dplyr::bind_rows(.) %>%
  dplyr::distinct(.) %>%
  tibble::add_column(., "Demographic Group" = .$`Demographic Characteristic`, .before = 1) %>%
  dplyr::mutate(`Demographic Group` = dplyr::if_else(grepl("(Y|y)ears", `Demographic Group`), "Age", `Demographic Group`),
                `Demographic Group` = dplyr::if_else(grepl("^((Female)|(Male))$", `Demographic Group`), "Sex", `Demographic Group`),
                `Demographic Group` = dplyr::if_else(grepl("^((Non-Hispanic White)|(Black \\(or African-American\\))|(Asian\\/Pacific Islander)|(Hispanic)|(American Indian/Alaska Native)|(Other)|(Unknown))$", `Demographic Group`), "Race", `Demographic Group`)
                ) %>%
  dplyr::filter(!is.na(`Total Medicare Enrollees`)) %>%
  dplyr::mutate_at(dplyr::vars(-Year, -`Demographic Group`, -`Demographic Characteristic`),
                   ~ suppressWarnings(as.numeric(.)))


cat("# Auto Generated. Do not edit by hand",
    "#' Total Medicare Enrollment:  Part A and/or Part B Enrollees, by Type of Entitlement and Demographic Characteristics",
    "#'",
    "#' Total Medicare Enrollment:  Part A and/or Part B Enrollees, by Type of Entitlement and Demographic Characteristics",
    "#'",
    "#' NOTES:  The enrollment counts are determined using a person-year methodology.  Numbers and percentages may not add to totals because of rounding.",
    "#'",
    "#' @source Centers for Medicare & Medicaid Services, Office of Enterprise Data and Analytics, CMS Chronic Conditions Data Warehouse.",
    "#'",
    "\"MDCR_ENROLL_AB_06\"",
    sep = "\n",
    file = "../R/MDCR_ENROLL_AB_06.R")

MDCR_ENROLL_AB_06 %<>% as.data.frame
save(MDCR_ENROLL_AB_06, file = "../data/MDCR_ENROLL_AB_06.rda")

