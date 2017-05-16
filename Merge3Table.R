#Laurent Cesaro
#Date 27/04/2017

#Merge 3 tables 

load("C:/Users/laurent cesaro/Documents/Cesaro/Data/MERGE_RAWDATA.RData")
RAWDATA<-df
RAWDATA<-RAWDATA[,c("LOT","PARAMETER","SITE_VALUE")]
colnames(RAWDATA)<-c("LOT","parameter","SITE_VALUE")

load("C:/Users/laurent cesaro/Documents/Cesaro/Data/MERGE_NCL.RData")
NCL<-df
NCL<-NCL[,c("parameter","parameterType","LCL","UCL")]
load("C:/Users/laurent cesaro/Documents/Cesaro/Data/MERGE_UCL.RData")
UCL<-df

#Merge 3 data.frames
new<-Reduce(function(x, y) merge(x, y, all=TRUE), list(RAWDATA, NCL, UCL))
#Select only rows with parameterType != NA
new<-subset(new, !is.na(new$parameterType))

#Transform in matrix
newMatrix<-as.matrix(new[,5:8])

for (i in 1:nrow(newMatrix)) {
  if(is.na(newMatrix[i,3])){
    newMatrix[i,3]<-newMatrix[i,1]
    newMatrix[i,4]<-newMatrix[i,2]
  }
}

#Transform matrix in data.frame
newMatrix<-data.frame(newMatrix)
#Merge 
new<-cbind(new[,1:4],newMatrix)