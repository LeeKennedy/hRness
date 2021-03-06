library(readr)
library(dplyr)

data <- read_csv("1609_1800M.csv")
colnames(data)[2] <- "Venue"
data <- data[,c(1:17)]

#Convert to odds and rearrange ----------------------------------------
data2 <- select(data, everything())%>%
        transmute(Date, 
                  Venue, 
                  Race, 
                  B1 = 1/(B1+1),
                  B2 = 1/(B2+1),
                  B3 = 1/(B3+1),
                  B4 = 1/(B4+1),
                  B5 = 1/(B5+1),
                  B6 = 1/(B6+1),
                  B7 = 1/(B7+1),
                  B8 = 1/(B8+1),
                  B9 = 1/(B9+1),
                  B10 = 1/(B10+1),
                  B11 = 1/(B11+1),
                  B12 = 1/(B12+1),
                  B13 = 1/(B13+1),
                  Win)
data3 <- data2[, c(1:3, 17, 4:16)]
data3a <- data3[,c(1:4)]

# peel off the positions only ----------------------------------------
data4 <- data3[,c(5:17)]
# Set position factors -----------------------------------------------
Factors <- rep(10,13)
n <- nrow(data4)
depth <- 4
pcnt_win_1 <- 0


for (h in 1:13) {
        for (g in 7:13) {
        Factors[h] = g
        
# Multiply position by factor ----------------------------------------
data5 <-data.frame(mapply(`*`,data4,Factors))

data6 <- data.frame(
        B1=numeric(),
        B2=numeric(),
        B3=numeric(),
        B4=numeric(),
        B5=numeric(),
        B6=numeric(),
        B7=numeric(),
        B8=numeric(),
        B9=numeric(),
        B10=numeric(),
        B11=numeric(),
        B12=numeric(),
        B13=numeric())


for (i in 1:n){
data6[i,] <- (rank(-data5[i,]))
}

data7 <- cbind(data3a, data6)

data7$flag = 0


for (j in 1:n) {
m <- data7$Win[j]+4
if (data7[j,m] <= depth) {data7$flag[j]=1}
}

pcnt_win <- round(sum(data7$flag)*100/n,2)

if (pcnt_win > pcnt_win_1) {
        pcnt_win_1 = pcnt_win
        factor_1 = Factors[h]
}
Factors[h] <- factor_1
}
}