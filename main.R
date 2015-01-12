#Snake Aka Python
#12 January 2015

library(sp)
library(raster)
library(rgdal)
library(ggplot2)


source('R/extracting.R')


download.file(url = "https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip", destfile = 'data/MODIS.zip', method = 'auto')
unzip('data/MODIS.zip', exdir = 'data')


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


spplot(JanuaryNdvi, zcol = 'January',add = TRUE, main = 'January NDVI')
spplot(AugustNdvi, zcol = 'August', add = TRUE, main = 'August NDVI')
spplot(AnnualNdvi, zcol ='layer', add = TRUE, main = 'Annual NDVI')
