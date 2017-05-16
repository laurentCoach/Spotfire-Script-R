#script to order a list of HBIN by average 
#author: Laurent Cesaro


bool = "False"
#Get only HBIN columns
nums <- DataTable[ , grepl( "HB" , names(DataTable) ) ]

#Get the means and then order the nums table by means
means<-colMeans(nums, na.rm = FALSE, dims = 1)
nums <- nums[,order(means,decreasing=FALSE)]


#Get good HBIN list then get the two table subset (good and bad)
if (nchar(Good) > 4){
  good<-unlist(strsplit(Good,","))
  numsBad <- nums[ , !(names(nums) %in% good)]
  numsGood <-nums[ , (names(nums) %in% good)]
}else{
  numsBad <- nums[ , !(names(nums) %in% Good)]
  bool <- "True"
}

#Get the columns names that will be on the graphs axises
outputAll <- colnames(nums)
outputBad <- colnames(numsBad)

if (bool == "False"){
outputGood <- colnames(numsGood)
outputGoodFinal <-paste(outputGood, collapse =',')
}
#Transfrom the chr list into a string, HB are separated with commas
outputAllFinal <- paste(outputAll, collapse=',' )
outputBadFinal <-  paste(outputBad, collapse=',' )


if (bool == "True") {
  outputGoodFinal = Good
}

