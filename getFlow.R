# Source the USGS flow download script
source('R/USGSflow.R')

# Define the USGS sites and start year to download data for:
USGSflow(
  sites = c('02307323','02307359','02307445','02309447','02309425','02307496',
           '02307498','02307674','02308935','02307780','02309200'),
  start_yr = 2003,
  outpath = 'Data/')
