USGSflow <- function(sites, start_yr, param = '00060', outpath){
  
  # DESCRIPTION:
  # ---------
  # The purpose of this functions is to download flow data from USGS gage sites
  # using the dataRetrieval package from USGS. The user can specify the sites of
  # interest, the parameter code, and the start year to download the data.
  # 
  
  # USAGE:    
  
  #         USGSflow(sites = c('000001', '000002', ...),
  #                  start_yr = 2003,
  #                  param = '00060',
  #                  outpath = 'path/to/save/flowdata.xlsx')
  
  # INPUTS:
  # -------
  # sites    = A vector of USGS site numbers to download data for.
  # start_yr = The year to start downloading data from.
  # param    = The parameter code to download data for. Default is '00060' for flow
  #            but can be changed to download other parameters.
  # outpath  = The path to save the output excel file containing the flow data.
  
  # OUTPUTS:
  # -------
  # 1) An excel file containing the flow data for the specified sites and parameter.
  
  # -----AUTHORS:-----
  # Alex Manos (9/10/2024)
  
  #-----------------------------------------------------------------------------
  
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
    write.xlsx(flow, paste0(outpath,'USGS_PC_Flow_',start_yr,'_',year(Sys.Date()),'.xlsx'))
  
}