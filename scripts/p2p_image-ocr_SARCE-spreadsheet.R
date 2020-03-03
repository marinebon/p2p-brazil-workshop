# * [Using the Tesseract OCR engine in R](https://cran.r-project.org/web/packages/tesseract/vignettes/intro.html)
# * [MNIST For ML Beginners](https://tensorflow.rstudio.com/tensorflow/articles/tutorial_mnist_beginners.html)
# * [OCR tables in R, tesseract and pre-pocessing images - Stack Overflow](https://stackoverflow.com/questions/42468845/ocr-tables-in-r-tesseract-and-pre-pocessing-images)

#library(tidyverse)
library(magrittr)
library(here)
library(magick)    # install.packages("magick")
library(tesseract) # install.packages("magick")

# [SARCE forms](http://sarce.cbm.usb.ve/for-scientists/)
img <- here("scripts/data/Datasheet-1-SARCE-II_v2_test.png")

# tesseract_download("spa") # run once
# https://ropensci.org/technotes/2017/08/17/tesseract-16/
text <- image_read(img) %>%
  image_resize("2000") %>%
  image_convert(colorspace = 'gray') %>%
  image_trim() %>%
  image_ocr(language = "eng")

cat(text)
cat(text, file=here("scripts/data/Datasheet-ocr.txt"))

eng <- tesseract("eng")

spa <- tesseract("spa")
#txt    <- ocr(img, engine = eng)
txt    <- ocr(img, engine = spa)
txt_df <- ocr_data(img, engine = eng)
cat(txt)

# googleAuthR ----
# https://cran.r-project.org/web/packages/googleAuthR/
#  Vignettes
# https://github.com/cloudyr/RoogleVision

install.packages(c("googleAuthR", "shinyjs"))
devtools::install_github("MarkEdmondson1234/googleID")

# https://lesliemyint.wordpress.com/2017/01/01/creating-a-shiny-app-with-google-login/
# https://console.developers.google.com/
require("RoogleVision") # install.packages("RoogleVision", repos = c(getOption("repos"), "http://cloudyr.github.io/drat"))
# devtools::install_github("cloudyr/RoogleVision")
library(googleAuthR)

### plugin your credentials
options("googleAuthR.client_id" = "803089665722-ueh8hbdmgq7nqm8jn20ml92lt592b7bk.apps.googleusercontent.com")
options("googleAuthR.client_secret" = "ekF1tfYuT0mDqBbYctkG3DhO")

## use the fantastic Google Auth R package
### define scope!
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/cloud-platform"))
googleAuthR::gar_auth()
googleAuthR::gar_auth("https://www.googleapis.com/auth/cloud-platform")

############
#Basic: you can provide both, local as well as online images:
o <- getGoogleVisionResponse("brandlogos.png")
o <- getGoogleVisionResponse(imagePath="brandlogos.png", feature="LOGO_DETECTION", numResults=4)
getGoogleVisionResponse("https://media-cdn.tripadvisor.com/media/photo-s/02/6b/c2/19/filename-48842881-jpg.jpg", feature="LANDMARK_DETECTION")

o <- getGoogleVisionResponse(imagePath="data/Datasheet-1-SARCE-II_v2_test.png", feature="TEXT_DETECTION", numResults=200)
o
View(o)
