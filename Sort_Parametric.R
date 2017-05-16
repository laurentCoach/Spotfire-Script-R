
require(data.table)
load("")
DT<-data.frame(input)
setDT(DT)
summary(DT)
DT<-DT[,-c(20:21)]
DT<-na.omit(DT)
#KW test on non NULL Q1 for all TEST_NUM_NAME 
KwTestQ3 <- DT[!is.na(WL_TEST_Q3), .(SPLIT,WL_TEST_Q1,TEST_NUM_NAME)][,kruskal.test("DT$WL_TEST_Q1" ~ factor("SPLIT"), na.action = "na.omit"), by = .(TEST_NUM_NAME)][,c("data.name","method","parameter","statistic"):=NULL]
suppressWarnings(KwTestQ3)
setnames(KwTestQ1, "p.value", "p.value Q1")

#KW test on non NULL Q3 for all TEST_NUM_NAME 
KwTestQ3 <- DT[!is.na(WL_TEST_Q3), .(SPLIT,WL_TEST_Q3,TEST_NUM_NAME)][,kruskal.test("WL_TEST_Q3" ~ factor("SPLIT"), na.action = "na.omit"), by = .(TEST_NUM_NAME)][,c("data.name","method","parameter","statistic"):=NULL]
setnames(KwTestQ3, "p.value", "p.value Q3")

#KW test on non NULL Median for all TEST_NUM_NAME 
KwTestM <- DT[!is.na(WL_TEST_MEDIAN), .(SPLIT,WL_TEST_MEDIAN,TEST_NUM_NAME)][, kruskal.test("WL_TEST_MEDIAN" ~ factor("SPLIT"), na.action = "na.omit"), by = .(TEST_NUM_NAME)][,c("data.name","method","parameter","statistic"):=NULL]
setnames(KwTestM, "p.value", "p.value Median")

#Merge All Kw results in one table
KwResult <- merge(KwTestQ1,KwTestM, by = "TEST_NUM_NAME")
KwResult <- merge(KwResult,KwTestQ3, by = "TEST_NUM_NAME")
#Replace NA by 0
#if 1, no diferrence between the splits
for (j in 2:4) set(KwResult,which(is.na(KwResult[[j]])),j,1)


#Minimum P.value computation
KwResult$Min.P.value <- apply(KwResult[,2:4], 1, min)

DT[kruskal.test("WL_TEST_Q1" ~ factor("SPLIT"), na.action = "na.omit")]

parameter<-data.frame(unique(DT$TEST_NUM_NAME))

nl<-nrow(DT)  
res<-NULL
stock<-NULL
for (i in 1:nl) {
  res<-kruskal.test(DT$WL_TEST_Q1, DT$SPLIT)
  stock<-c(stock, res)
}
