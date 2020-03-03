# shiny::runApp("oauth_shiny", launch.browser=T, port=1221)
library(googleAuthR)
library(shiny)
options(googleAuthR.scopes.selected = "https://www.googleapis.com/auth/urlshortener")
options("googleAuthR.webapp.client_id" = "803089665722-ueh8hbdmgq7nqm8jn20ml92lt592b7bk.apps.googleusercontent.com")
options("googleAuthR.webapp.client_secret" = "ekF1tfYuT0mDqBbYctkG3DhO")

# API key = AIzaSyA5Br6Tt_RdnP9NAAjalB02XwS-HOJKyDI
shorten_url <- function(url){
  
  body = list(
    longUrl = url
  )
  
  f <- gar_api_generator("https://www.googleapis.com/urlshortener/v1/url",
                         "POST",
                         data_parse_function = function(x) x$id)
  
  f(the_body = body)
  
}