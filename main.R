#Snake Aka Python
#12 January 2015


#Library calling
library(sp)
library(raster)
library(rgdal)
library(ggplot2)

#Call the function
source('R/extracting.R')


download.file(url = "https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip", destfile = 'data/MODIS.zip', method = 'auto')
unzip('data/MODIS.zip', exdir = 'data')


#Get the data for municipalities
nlCity <- getData('GADM',country='NLD', level=3)


#ModisPath <- list.files(pattern = glob2rx('data/MOD13A3.A2014001.h18v03.005.gri'), full.names = TRUE)
ModisNDVI <- brick('data/MOD13A3.A2014001.h18v03.005.grd')


#Transform the the Netherlands city data to the modis dataset
nlCityUTM <- spTransform(nlCity, CRS(proj4string(ModisNDVI)))


# mask the Modis ndvi with the netherland
modisMask <- mask(ModisNDVI, nlCityUTM)


#Select NDVI for January and August
January <- modisMask$January
August <- modisMask$August


# Calculate the annual mean NDVI value 
Annual <- calc(modisMask, fun=mean)


JanuaryNdvi <- extracting(January, nlCityUTM)
AugustNdvi <- extracting(August, nlCityUTM)
AnnualNdvi <- extracting(Annual, nlCityUTM)


#Convert to data frame
JanuaryMax <- data.frame(JanuaryNdvi)
AugustMax <- data.frame(AugustNdvi)
AnnualMax <- data.frame(AnnualNdvi)


#Selection of the Greener City in any occasion 
GreenCityJanuary <- subset(JanuaryMax, JanuaryMax$January == max(JanuaryMax$January, na.rm = TRUE), select = c(NAME_2))
#The Greener City for January is Littenseradiel
GreenCityAugust <- subset(AugustMax, AugustMax$August == max(AugustMax$August, na.rm = TRUE), select = c(NAME_2))
#The Greener City for August is Vorden
GreenCityJAnnual <- subset(AnnualMax, AnnualMax$layer == max(AnnualMax$layer, na.rm = TRUE), select = c(NAME_2))
#The Greener City for all the year is Graafstroom


spplot(JanuaryNdvi, zcol = 'January', main = 'January NDVI')
spplot(AugustNdvi, zcol = 'August', main = 'August NDVI')
spplot(AnnualNdvi, zcol ='layer', main = 'Annual NDVI')

