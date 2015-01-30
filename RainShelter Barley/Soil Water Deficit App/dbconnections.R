# connect to database
DBConnection <- function(){
  library (RPostgreSQL)
  drv <- dbDriver('PostgreSQL')
  creds <- scan('C:/GitHubRepos/Summer Project - R/RainShelterBarley/RainShelterdbLogin.txt',what='character',sep=",")
  con <- dbConnect(drv, dbname='rainshelter', host='aklpdb22.pfr.co.nz', port='5432', user=creds[[1]], password=creds[[2]])
  return (con)
}

#close db connection
closeDBConnection <- function (con) {
  dbDisconnect(con)
}