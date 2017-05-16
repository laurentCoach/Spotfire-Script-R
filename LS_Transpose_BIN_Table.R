require(data.table)
load("C:/Users/laurent cesaro/Documents/Cesaro/Data/LSDataBL.RData")
DT <- data.table(input)

# Calculate BIN percentage
DT[,VALUE := WL_BIN_CNT*100/WL_PART_CNT]

# change bin name : concatenate BIN_TYPE & BIN_NUMBER and add PAss prior for "P" Bin only
DT[BIN_PASS_FAIL == "P", Bin := paste("PASS_",BIN_TYPE,BIN_NUMBER,sep ="")]
DT[BIN_PASS_FAIL == "F", Bin := paste("FAIL_",BIN_TYPE,BIN_NUMBER,sep ="")]

#transpose BIN long table to wide
BINCorr <- dcast(DT,
                  LOT_ID + SUBLOT_ID + CAM_PRODUCT + JOB_NAME + JOB_REV
                    CAM_OPERATION + WL_PART_CNT + WL_GOOD_CNT  ~ Bin,
                  value.var = "VALUE",
                  fill = 0)

#Calculate Yield
BINCorr <- BINCorr[,Yield := WL_GOOD_CNT*100/WL_PART_CNT][order(LOT_ID,SUBLOT_ID)]

#Reorder column names : Bin pass first and Bin sorted by number
BINname <- unique(DT[,BIN_NUMBER,Bin])[order(BIN_NUMBER)][["Bin"]]

setcolorder(BINCorr,c("LOT_ID","SUBLOT_ID","CAM_PRODUCT","JOB_NAME","JOB_REV","CAM_OPERATION",
                       "WL_PART_CNT","WL_GOOD_CNT","Yield",BINname))

#Unpivot table
BINCorr<-melt(BINCorr, id.vars = c("LOT_ID","SUBLOT_ID","CAM_PRODUCT","JOB_NAME","JOB_REV","CAM_OPERATION",
                                     "WL_PART_CNT","WL_GOOD_CNT","Yield"),
               measure.vars = BINname)

#Create new variable to add to create a limit data condition in barchart-->properties-->data
BINCorr$BIN_TYPE <- substr(BINCorr$variable, 1, 1)
