USGSflow <- function(sites, start_yr, param = '00060', ptile = FALSE){
  
  # Load packages:
  if (!nzchar(system.file(package = "librarian")))
    install.packages("librarian")
  
  librarian::shelf(
    librarian, dplyr, readxl, openxlsx, lubridate, dataRetrieval
  )
  
  # Get flow data and change site names to Pinellas County water quality site names:
  flow <- readNWISdv(
    siteNumbers = sites,
    parameterCd = param,
    startDate = paste0(start_yr, '-01-01'),
    endDate = Sys.Date()
    ) |>
    select(
      Source = agency_cd, Site = site_no, Date, Q = X_00060_00003
      ) |>
    mutate(
      Site = case_when(
      Site == '02307323' ~ '04-02',
      Site == '02307359' ~ '04-03',
      Site == '02307445' ~ '04-04',
      Site == '02309447' ~ '08-03',
      Site == '02309425' ~ '10-02',
      Site == '02307496' ~ '06-03',
      Site == '02307498' ~ '06-06',
      Site == '02307674' ~ '14-10',
      Site == '02308935' ~ '35-10',
      Site == '02307780' ~ '22-12',
      Site == '02309200' ~ '17-03')
    ) 
  
    # Save flow data
    write.xlsx(flow, paste0('USGS_PC_Flow_',start_yr,'_',year(Sys.Date()),'.xlsx'))
  
}