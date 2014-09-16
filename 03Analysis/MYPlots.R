library("ggplot2")
options(java.parameters="-Xmx2g")
library(rJava)
library(RJDBC)

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="C:/Program Files/Java/jdk1.7.0_45/ojdbc6.jar")

# In the following, use your username and password instead of "CS347_prof", "orcl_prof" once you have an Oracle account
possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521:orcl", "C##cs347_acc2634", "orcl_acc2634"),
  error=function(e) e
)
if(!inherits(possibleError, "error")){

complaints <- dbGetQuery(jdbcConnection, "select * from fin_complaint")
companies <- dbGetQuery(jdbcConnection, "select * from fin_company")
population <- dbGetQuery(jdbcConnection, "select * from population")

  dbDisconnect(jdbcConnection)
}

#####JESSE-MAPS#############

#Show head of complaints table
head(complaints)

#Show head of companies
head(companies)

#Show head of population
head(population)

#Add counts as 1 for summation purposes later on
complaints$COUNT <- rep(1, nrow(complaints))

#Consolidate zips and their counts to separate table
ziptable <- aggregate(COUNT ~ ZIP_CODE, complaints, sum)

#Load zipcode library data that map to lat/long points for each zip
library(zipcode)
data(zipcode)

#Load sqldf package for SQL-like queries and combine our zip counts table to zipcode lat/lon table
library(sqldf)
merged <- sqldf('select zip, state, latitude, longitude, COUNT as count from zipcode, ziptable where zip=ZIP_CODE')

#Plotting each zip as a point with color coded count
g<-ggplot(data=merged) + geom_point(aes(x=longitude, y=latitude, colour=count), size=1) + geom_jitter(mapping=aes(x=longitude, y=latitude),alpha = 0.1) + ggtitle("Complaints by Zip Code in the United States") 
g = g + theme_bw() + scale_x_continuous(limits = c(-125,-66), breaks = NULL)
g = g + scale_y_continuous(limits = c(25,50), breaks = NULL)
g = g + labs(x=NULL, y=NULL)
g

#This just looks like a population map, so try Using alpha transparency to see complaint counts for zip
g<-ggplot(data=merged) + geom_point(aes(x=longitude, y=latitude, alpha=count), size=1) + geom_jitter(mapping=aes(x=longitude, y=latitude),alpha = 0.1)
g = g + theme_bw() + scale_x_continuous(limits = c(-125,-66), breaks = NULL) + ggtitle("Transparent Complaints by Zip Code in the United States") 
g = g + scale_y_continuous(limits = c(25,50), breaks = NULL)
g = g + labs(x=NULL, y=NULL)
g

#Merge population info by zip into zipcode table to account for pop and add ratio
merged <- sqldf('select zip, state, latitude, longitude, count, population from merged, population where merged.zip=population.ZIPCODE')
merged$ratio <- as.numeric(merged$count)/as.numeric(merged$POPULATION)

#Remove infinite values stemming from a couple missing values in tables
merged$ratio[is.infinite(merged$ratio)] <- 0
merged <- subset(merged, ratio<1)

#Sort by count/population ratio and remove useless 0 values
mergedsorted <- merged[order(merged$ratio) , ]
mergedsorted<-subset(mergedsorted, ratio>0)
mergedsorted$level <- 0

#Give rows a level for heatmap
mergedsorted[1:5809, 'level'] <- 1
mergedsorted[5810:11619, 'level'] <- 2
mergedsorted[11620:17426, 'level'] <- 3

#Plot again taking population into account
g<-ggplot(data=mergedsorted) + geom_point(aes(x=longitude, y=latitude, colour=factor(level), size=1), size=1, alpha=1, position=position_jitter(width=.3, height=.3)) + scale_colour_manual(values=c("green", "orange", "red")) + ggtitle("Ratio of Complaints to Population by ZIP Code in the United States") 
g = g + theme_bw() + scale_x_continuous(limits = c(-125,-66), breaks = NULL)
g = g + scale_y_continuous(limits = c(25,50), breaks = NULL)
g = g + labs(x=NULL, y=NULL)
g

#######///////////JESSE-MAPS##########



