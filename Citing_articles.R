
#Who cited a publication?

#What we need
#1. DOI of target article
#2. Use OpenCitations API to retrieve data
# - https://opencitations.net/index/coci
#3. Use rcrossref to obtain meta-data on articles citing target article


#Load package
library(rjson)
library(rcrossref)
require(fulltext)
require(bib2df)

#1. DOI of target article
doi <- "10.1111/nph.13572"
#2. Retrieve data from OpenCitations API
#query
opcit <- paste0("https://opencitations.net/index/coci/api/v1/citations/", doi)

#Submit query
result <- rjson::fromJSON(file = opcit)

#Extract dois of citing articles
citing <- lapply(result, function(x){
  x[['citing']]
})
# a vector with DOIs, each of which cite the target article
citing <- unlist(citing) 
citingdata <- rcrossref::cr_cn(citing)
write.csv(citingdata[[1]], file="Citingdoi.bib")


url = "http://www.crossref.org/openurl/"
key = "cboettig@ropensci.org"

rcrossref_ua <- function() {
  versions <- c(paste0("r-curl/", utils::packageVersion("curl")),
                paste0("crul/", utils::packageVersion("crul")),
                sprintf("rOpenSci(rcrossref/%s)", 
                        utils::packageVersion("rcrossref")),
                get_email())
  paste0(versions, collapse = " ")
}

get_email <- function() {
  email <- Sys.getenv("crossref_email")
  if (identical(email, "")) {
    NULL
  } else {
    paste0("(mailto:", val_email(email), ")")
  }
}



args <- list(id = paste("doi:", doi, sep = ""), pid = as.character(key),
             noredirect = as.logical(TRUE))
cli <- crul::HttpClient$new(
  url = url,
  headers = list(
    `User-Agent` = rcrossref_ua(), `X-USER-AGENT` = rcrossref_ua()
  )
)
