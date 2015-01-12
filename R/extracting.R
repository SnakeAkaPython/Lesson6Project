#Snake Aka Python
#12 January 2015


extracting <- function(data, city) {
  result <- extract(data, city, fun = mean, na.rm =TRUE, sp = TRUE)
  return(result)
}



