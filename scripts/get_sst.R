# Antonio Olinto Avila-da-Silva, Instituto de Pesca, Brasil
# script to process Aqua MODIS Sea Surface Temperature
# Monthly means 9 km resolution
# files downloaded from http://oceancolor.gsfc.nasa.gov/cgi/l3
# all .L3m_MO_SST_sst_9km.nc files must be in the working directory
# the script will open each nc file, read lon, lat and sst data,
# select data from a specific area and write them into
# a single csv file named MODISA_sst.csv
# Some reference pages
# http://geog.uoregon.edu/GeogR/topics/netCDF-read-ncdf4.html
# https://scottishsnow.wordpress.com/2014/08/24/many-rastered-beast/

# load libraries
# ncdf4 needs libnetcdf-dev netcdf-bin in Linux
# install.packages(c("ncdf4"))
library("ncdf4")

# set working directory
setwd("/mnt/Dados02/MODIS/SST")   # indicate the path to the files
file.exists("MODISA_sst.csv")     # caution new data will be appended to
this file if it already exists
# file.rename("MODISA_sst.csv","MODISA_sst.old")
# file.remove("MODISA_sst.csv")

# list and remove objects
ls()
rm(list = ls())

# set the study area
lonmax<--40
lonmin<--50
latmax<--22
latmin<--29

# create a list of files and indicate its length
(f <- list.files(".", pattern="*.L3m_MO_SST_sst_9km.nc",full.names=F))
(lf<-length(f))

# variable
var<-"sst"

for (i in 1:lf) {
  # progress indicator
  print(paste("Processing file",i,"from",length(f),sep=" "))
  # open netCDF file
  data<-nc_open(f)
  # extract data
  lon<-ncvar_get(data,"lon")
  lat<-ncvar_get(data,"lat")
  value<-ncvar_get(data,var)
  unit<-ncatt_get(data,var,"units")$value
  # matrix to data.frame
  dimnames(value)<-list(lon=lon,lat=lat)
  dat.var<-melt(value,id="lon")
  # select data from the study area taking out missing data
  dat.varSAtmp<-subset(dat.var,lon<=lonmax & lon>=lonmin & lat<=latmax &
                         lat>=latmin & value<45)
  # extract date information
  dateini<-ncatt_get(data,0,"time_coverage_start")$value
  dateend<-ncatt_get(data,0,"time_coverage_end")$value
  
  datemean<-mean(c(as.Date(dateend,"%Y-%m-%dT%H:%M:%OSZ"),as.Date(dateini,"%Y-%m-%dT%H:%M:%OSZ")))
  year<-substring(datemean,0,4)
  month<-substring(datemean,6,7)
  # prepare final data set
  
  dat.varSA<-data.frame(rep(as.integer(year,nrow(dat.varSAtmp))),rep(as.integer(month,nrow(dat.varSAtmp))),
                        dat.varSAtmp,rep(unit,nrow(dat.varSAtmp)),rep(var,nrow(dat.varSAtmp)))
  names(dat.varSA)<-c("year","month","lon","lat","value","unit","var")
  # save csv file
  fe<-file.exists("MODISA_sst.csv")
  
  write.table(dat.varSA,"MODISA_sst.csv",row.names=FALSE,col.names=!fe,sep=";",dec=",",append=fe)
  # close connection
  nc_close(data)
  # clean workspace
  
  rm(data,lon,lat,value,unit,dat.var,dat.varSAtmp,dateini,dateend,datemean,year,month,dat.varSA,fe)
}
rm(var,f,i,latmax,latmin,lf,lonmax,lonmin)


*CHL_a=====*
  
  # Antonio Olinto Avila-da-Silva, Instituto de Pesca, Brasil
  # script to process Aqua MODIS Chlorophyll Concentration OCx Algorithm
  # Monthly means 9 km resolution
  # see http://oceancolor.gsfc.nasa.gov/WIKI/OCChlOCI.html
  # files downloaded from http://oceancolor.gsfc.nasa.gov/cgi/l3
  # all .L3m_MO_CHL_chlor_a_9km.nc files must be in the working directory
  # the script will open each nc file, read lon, lat and chl data,
  # select data from a specific area and write them into
  # a single csv file named MODISA_chl.csv
  # Some reference pages
# http://geog.uoregon.edu/GeogR/topics/netCDF-read-ncdf4.html
# https://scottishsnow.wordpress.com/2014/08/24/many-rastered-beast/

# load libraries
# ncdf4 needs libnetcdf-dev netcdf-bin in Linux
# install.packages(c("ncdf4","reshape2"))
library("ncdf4")
library("reshape2")

# set working directory
setwd("/mnt/Dados02/MODIS/CHL")   # indicate the path to the files
file.exists("MODISA_chl.csv")     # caution new data will be appended to
this file if it already exists
# file.rename("MODISA_chl.csv","MODISA_chl.old")
# file.remove("MODISA_chl.csv")

# list and remove objects
ls()
rm(list = ls())

# set the study area
lonmax<--40
lonmin<--50
latmax<--22
latmin<--29

# create a list of files and indicate its length
(f <- list.files(".", pattern="*.L3m_MO_CHL_chlor_a_9km.nc",full.names=F))
(lf<-length(f))

# variable
var<-"chlor_a"

for (i in 1:lf) {
  # progress indicator
  print(paste("Processing file",i,"from",length(f),sep=" "))
  # open netCDF file
  data<-nc_open(f)
  # extract data
  lon<-ncvar_get(data,"lon")
  lat<-ncvar_get(data,"lat")
  value<-ncvar_get(data,var)
  unit<-ncatt_get(data,var,"units")$value
  # matrix to data.frame
  dimnames(value)<-list(lon=lon,lat=lat)
  dat.var<-melt(value,id="lon")
  # select data from the study area taking out missing data
  dat.varSAtmp<-na.omit(subset(dat.var,lon<=lonmax & lon>=lonmin &
                                 lat<=latmax & lat>=latmin))
  # extract date information
  dateini<-ncatt_get(data,0,"time_coverage_start")$value
  dateend<-ncatt_get(data,0,"time_coverage_end")$value
  
  datemean<-mean(c(as.Date(dateend,"%Y-%m-%dT%H:%M:%OSZ"),as.Date(dateini,"%Y-%m-%dT%H:%M:%OSZ")))
  year<-substring(datemean,0,4)
  month<-substring(datemean,6,7)
  # prepare final data set
  
  dat.varSA<-data.frame(rep(as.integer(year,nrow(dat.varSAtmp))),rep(as.integer(month,nrow(dat.varSAtmp))),
                        dat.varSAtmp,rep(unit,nrow(dat.varSAtmp)),rep(var,nrow(dat.varSAtmp)))
  names(dat.varSA)<-c("year","month","lon","lat","value","unit","var")
  # save csv file
  fe<-file.exists("MODISA_chl.csv")
  
  write.table(dat.varSA,"MODISA_chl.csv",row.names=FALSE,col.names=!fe,sep=";",dec=",",append=fe)
  # close connection
  nc_close(data)
  # clean workspace
  
  rm(data,lon,lat,value,unit,dat.var,dat.varSAtmp,dateini,dateend,datemean,year,month,dat.varSA,fe)
}
rm(var,f,i,latmax,latmin,lf,lonmax,lonmin)