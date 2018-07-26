### Importing datasets
library(readxl)
library(foreign)
library(haven)
in_dir <- "/home/christopher/Urban_food_landscapes/Urban_food_landscapes/data"

infilename <- "homescan_philadelphia_2008.dta"
infilename <- file.path(in_dir, infilename)
df_input <- read_dta(infilename)


###### Library used (taken from Benoit)

library(gtools)                              # loading some useful tools 
library(sp)                                  # Spatial pacakge with class definition by Bivand et al.
library(spdep)                               # Spatial pacakge with methods and spatial stat. by Bivand et al.
library(rgdal)                               # GDAL wrapper for R, spatial utilities
library(raster)
library(rasterVis)                           # Raster plotting functions
library(parallel)                            # Parallelization of processes with multiple cores
library(plyr)                                # Various tools including rbind.fill
library(rgeos)                               # Geometric, topologic library of functions
library(colorRamps)                          # Palette/color ramps for symbology
library(ggplot2)
library(dplyr)
library(sf)
library(tigris)
library(classInt)
library(acs) # census api
library(leaflet)

library(tidyverse)
options(tigris_class = "sf")
options(tigris_use_cache = TRUE)

function_processing_data <- "BP_exploration_of_data_functions.R" #Reading in of functions script from Benoit
script_path <- "/home/christopher/Urban_food_landscapes/Urban_food_landscapes" #path to script #PARAM 
source(file.path(script_path,function_processing_data)) #source all functions used in this script 1.

tracts_phil <- metro_tracts("Philadelphia-Camden-Wilmington, PA-NJ-DE-MD")

plot(tracts_phil$geometry)

#### Linking of df_input and tracts files using $TRACT as unique identifier

##df_input <- rename(df_input, replace = ('tract_strg' = 'TRACTCE')) # rename column (didn't work)
names(df_input)[names(df_input)=="tract_strg"] <- "TRACTCE" 

df_input_map <- merge(tracts_phil, df_input, by = 'TRACTCE')# join didn't work, merge did


######## END of Script.
metros <- core_based_statistical_areas(cb = TRUE) # get core stat areas

### Get outline

selected_cities <- c("Philadelphia")
metro_area <- filter(metros, grepl(selected_cities[1], NAME)) ## Anything with Philadelphia in the name
plot(metro_area$geometry)
metro_area <- filter(metro_area, NAME == "Philadelphia-Camden-Wilmington, PA-NJ-DE-MD") ## only if multiple areas correspond

### Download tracts for all relevant states 

dfw <- rbind_tigris(
  tracts("PA", cb = TRUE), 
  tracts("NJ", cb = TRUE),
  tracts("DE", cb = TRUE),
  tracts("MD", cb = TRUE)
)
plot(dfw$geometry)

###


####
View(homescan_philadelphia_2008)
df_input <- read.dta13(in_dir, infilename)


list.files(path = in_dir, pattern="*.xls")
df_input <- read_xls(lf[1])