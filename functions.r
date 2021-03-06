columnmean  <- function(y, removeNA = TRUE) {
  nc <- ncol(y)
  means <- numeric(nc)
  for (i in 1:nc)
  {
    means[i] <- mean(y[,i], na.rm = removeNA)
  }
  means  
}

pollutantmean <- function(folder, pm, id=1:322){
  
  setwd(paste("C:/Users/KSGI/Desktop/Data Science/specdata/", folder, sep=""))
  
  files <- list.files(pattern = ".csv")
  fil <- lapply(files, read.csv, h=T, sep=",")
  final <- do.call(rbind, fil)
    
    monitor <- subset(final, subset=ID %in% id)
    df <- data.frame(na.omit(monitor))
    
    mm <- mean(df[,pm]) 
    print(round(mm,3))
  
}
pollutantmean(folder="specdata", pm ="sulfate", id = c(1:10))

library(gtools)

complete <- function(folder, id=1:322){
  setwd(paste("C:/Users/KSGI/Desktop/Data Science/specdata/", folder, sep=""))
  
  files <- list.files(pattern = ".csv")
  fil <- lapply(files, read.csv, h=T, sep=",")
  final <- do.call(rbind, fil)
  nobs <- numeric()
  
  for (i in id)
  {  
      monitor <- final[which(final$ID==i),]
      comple <- complete.cases(monitor)
      com <- sum(comple)
      nobs <- c(nobs, com)
  }
  df1 <- data.frame(id, nobs)
  df1
}

complete(folder = "specdata", id = 30:25)

corr <- function(folder, threshold=0){
  setwd(paste0("C:/Users/KSGI/Desktop/Data Science/specdata/", folder, sep=""))
  
  files <- list.files(pattern = ".csv")
  fil <- lapply(files, read.csv, h=T, sep=",")
  final <- do.call(rbind, fil)
  
  vcor <- numeric()
  
  for (i in 1:length(unique(final$ID))){
    
    co <- na.omit(final[which(final$ID==i),])
    
    if(nrow(co) > threshold) {
      cors <- cor(co$sulfate, co$nitrate)
      vcor <- c(vcor, cors)
    }
    
  }
  print(vcor)
}

# How to use split and apply functions ##
library(datasets)
head(iris)
fac <- split(iris, iris$Species)

ss <- lapply(fac, function (x) colMeans(x[, c()]))

#invisible(x) <- # prevents autoprinting of a functions last argument


fileurl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

fil <- xmlTreeParse(fileurl, useInternalNodes = TRUE)

rootNode <- xmlRoot(fil)
xmlName(rootNode)
xs <-xpathSApply(rootNode, "//name", xmlValue)

length(xs[xs==21231])

###Dplyr funtcions ##
by_package <- group_by(cran, package)

pack_sum <- summarize(by_package,
                      count =n() ,
                      unique = n_distinct(ip_id),
                      countries =n_distinct(country) ,
                      avg_bytes = mean(size))

quantile(pack_sum$count, probs=0.99)

top_counts <- filter(pack_sum, count >679)
top_counts_sorted <- arrange(top_counts, desc(count))

top_unique <- filter(pack_sum, unique >465)
top_unique_sorted <- arrange(top_unique, desc(unique))

### Read MySQL data ##
ucsDB <- dbConnect(MySQL(), user="genome", host="genome-euro-mysql.soe.ucsc.edu")
result <- dbGetQuery(ucsDB, "show databases;")

dbDisconnect(ucsDB)

## choose specific DBs###

hg19 <- dbConnect(MySQL(), user="genome", db= "hg19", host="genome-euro-mysql.soe.ucsc.edu")

tabl <- dbListTables(hg19)
tabl
tabl[1:5]
dbListFields(hg19, "affyU133Plus2") ## get List of table names like showTables command
dbGetQuery(hg19, "select count(*) as nrows from affyU133Plus2") ## write SQL queries  

affyData <- dbReadTable(hg19, "affyU133Plus2") ## get the data in table format

query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3") ### select subset of data
ff <- fetch(query)
quantile(ff$misMatches)

dbDisconnect(hg19) ## always close the connection.


##### HDF5 data - hiercarchical data format ####

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.12")

BiocManager::install("rhdf5")

creat <- h5createFile("example.h5")
creat


### Reading from the web - ReadLines###

con <-url("https://scholar.google.com/citations?hl=en&user=HI-I6C0AAAAJ")
htmlCode <- readLines(con)

close(con)
htmlCode

library(XML)

url <- "https://scholar.google.com/citations?hl=en&user=HI-I6C0AAAAJ"
html <- htmlTreeParse(url, useInternalNodes = TRUE)
xpathSApply(html, "//title", xmlValue)

### Using httr package - works best ###
library(httr); html <- GET(url)
con <- content(html, as="text")
parsehtml <- htmlParse(con, asText = TRUE)
xpathSApply(parsehtml, "//title", xmlValue)

## We can use the authenticate argument in the GET function to access websites that need password###

## READ APIS to download data - Application Porgramming Interfaces

library(httr)
myapp <- oauth_app("twitter", key="yourConsumerKeyHere", secret = "yourConsumerSecretHere")
sig <- sign_oauth1.0(myapp, 
                       token = 'yourTokenHere'
                        , token_secret = "yourTokenSecretHere")

homeTL <- GET("http://api.twitter.com/1.1/statuses/home_timeline.json", sig)
json1 <- content(homeTL)
json2 <-jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]

#### Foreign package for different types of data - SAS, SPSS etc
#### EBImage from bioconductor for imaes
#### sweeve, tuneR for music data

library(reshape)
head(mtcars)

mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id.vars = c("carname","gear", "cyl"), measure.vars = c("mpg", "hp"))
head(carMelt)
tail(carMelt)

## the opposite of melt is dcast #like proc transpose.#

dcast

## test

if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://opendata.arcgis.com/datasets/53319332a909407e8ee52ae8ea79663d_0.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D"
download.file(fileUrl, destfile = "./data/restaurants.csv",  method = "curl") ### store the file as "acs" defined in the quiz
rests <- read.csv("./data/restaurants.csv", header = TRUE, sep = ",")


chicago <- readRDS("chicago.rds")

#### Metacharacters
# ^ letter <- matches the beginning of sentences with the sequence of letters
# letters$ <- matches the end of a sentence.
# [Aa] [Cd] <- letters in square brackets match patterns throughout a text
# [^?.]$ <- when ^in character classes it specifies to NOT look at these characters (at the end of sentence here)
# . <- specifies any character (e.g. one.two will return one-two, one/two etc)
# | <- is used to specify OR (so combine 2 metacharacters)
