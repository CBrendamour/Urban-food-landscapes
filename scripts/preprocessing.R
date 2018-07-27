### Importing datasets
library(readxl)
library(foreign)
library(haven)
in_dir <- "/home/christopher/Urban_food_landscapes/Urban_food_landscapes/data"

infilename <- "homescan_philadelphia_2008.dta"
infilename <- file.path(in_dir, infilename)
df_input <- read_dta(infilename)


###### Libraries used

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

tracts_phil <- metro_tracts("Philadelphia-Camden-Wilmington, PA-NJ-DE-MD") ## insdert name of metro region to be analyzed here

plot(tracts_phil$geometry)

#### Linking of df_input and tracts files using $TRACT as unique identifier

names(df_input)[names(df_input)=="tract_strg"] <- "TRACTCE" # renaming to allow for a merge by unique ID

df_input_map <- merge(tracts_phil, df_input, by = 'TRACTCE')# join didn't work, merge did





### Creating output for presentation: share of hh per tract that did buy at a store in a different zipcode
# Preprocessing includes making sure store_zip3 and zipcode are both numeric, and create an additonal column 'zipcombo'
# where TRUE indicates if hh bought outside (i.e. zipcode-store_zip3 = 0). Important not to include the lines
# with no value for store_zip!!

df_tsummary <- aggregate(hhid ~ TRACTCE, data = df_input_map, FUN = length)
df_tripsummary <- aggregate(trip_code_uc ~ TRACTCE, data = df_input_map, FUN = length)
df_map <- join(df_tsummary, df_tripsummary, by = "TRACTCE")
df_map2 <- merge(tracts_phil, df_map, by = 'TRACTCE')


df_input_map$store_zip3 <- as.numeric(df_input_map$store_zip3)
df_input_map2 <- df_input_map[!is.na(df_input_map$store_zip3),]

df_map2 <- mutate(df_map2, tperhh = trip_code_uc/hhid)

df_input_map$store_zip3 == df_input_map$zipcode[1:3]
  
format(12345,digit=3)

test_str <-"123test"
substr(test_str, start = 1, stop = 3)
?nchar
df_input_map2 <- mutate(df_input_map,
               zipcombo = zipcode - store_zip3)


df %>% 
  mutate(BdivA = MetricB/MetricA) %>% 
  group_by(Brands, Channels) %>% 
  summarize(mean_BdivA = mean(BdivA)) 


######## END of Script #####




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