
### Using Bio-Oracle dataset####

install.packages("sdmpredictors")
install.packages("leaflet")
install.packages("rgdal")

# Load package 
library(sdmpredictors) 

# Explore datasets in the package 
list_datasets() 
list_datasets(terrestrial = FALSE, marine = TRUE)
head(list_layers(datasets))
list_layers(c("Bio-ORACLE"))$layer_code

library(raster)
temp<-raster(file.choose())
summary(temp)
plot(temp)
temp.max.bottom <- load_layers("BO2_tempmax_bdmax") 
head( rasterToPoints( temp ) )
head( rasterToPoints( temp.max.bottom ) )
coords<-data.frame(lon=-179.9583, lat=89.95833)
coordinates(coords)<-c("lon","lat")

#extracting multiple values
extract(x=temp.max.bottom,y=coords)
coords<-data.frame(lon=c(-179.9583,-179.8750), lat=c(89.95833,89.95833))

### ploting a nice map ####

atlantic.ext <- extent(-70,20,-60,20)#(xmin,xmax,ymin,ymax) 
temp.max.bottom.crop <- crop(temp.max.bottom, atlantic.ext) 

my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127")) 
plot(temp.max.bottom.crop,col=my.colors(1000),axes=FALSE, box=FALSE) 
title(cex.sub = 1.25, sub = "Maximum temperature at the sea bottom (?C)") 

plot(temp.max.bottom,col=my.colors(1000),axes=FALSE, box=FALSE) 

############# Mixed models ##########

beaches<-read.table(file.choose(),header=TRUE)
Beta <- vector(length = 9)
for (i in 1:9){
Mi <- summary(lm(Richness ~ NAP,
subset = (Beach==i), data=beaches))
Beta[i] <- Mi$coefficients[2, 1]}
Beta

library(nlme)
beaches$fBeach <- factor(beaches$Beach)
Mlme1 <- lme(Richness ~ NAP, random = ~1 | fBeach,
data = beaches)
summary(Mlme1)



