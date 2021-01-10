library(scholar)
library(jsonlite)
library(ggplot2)
library(ggstance)
library(ggimage)
library(ggtree)


#Sys.setenv(http_proxy="http://127.0.0.1:43723")


id <- 'hj0LXQcAAAAJ&hl'

profile <- tryCatch(get_profile(id), error = function(e) return(NULL))
if (!is.null(profile)) {
    profile$date <- Sys.Date()
    cat(toJSON(profile), file ="profile.json")
}

citation <- tryCatch(get_citation_history(id), error = function(e) return(NULL))

if (is.null(citation)) {
    citation <- tinyscholar::tinyscholar(id)$citation
    citation <- citation[-1, ] # remove 'total' row
    names(citation) <- c("year", "cites")
    citation$year <- as.numeric(citation$year)
}

if (!is.null(citation)) {
    cat(toJSON(citation), file = "citation.json")
}

citation <- fromJSON("citation.json")
citation$year <- factor(citation$year)

png("citation.png", bg = "transparent")
barplot(citation$cites,main="data from Google Scholar", horiz=TRUE,names.arg=citation$year,las=1)
dev.off()

#library(magick)
#p <- image_read("citation.png")
#p <- image_transparent(p, "white")
#image_write(p, path="citation.png")
