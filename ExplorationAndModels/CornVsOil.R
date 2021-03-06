#corn vs oil, correlation of price 
library(Quandl)
library(dplyr)
library(reshape2)
library(lubridate)
library(tidyr)
library(ggplot2)

Quandl.api_key("")

#pull weekly data for each of the past 13 years 
startdate='2011-01-01'

wti = Quandl("CHRIS/CME_CL1", collapse = "month", start_date=startdate, order='asc')
wti$lagd1 <- c(0,diff(wti$Settle))
#wti <- mutate(wti, posGain = case_when(lagd1 > 3 ~ 1, TRUE ~ 0))
wti$group = "wti"

wti4 = Quandl("CHRIS/CME_CL4", collapse = "month", start_date=startdate, order='asc')
wti4$lagd1 <- c(0,diff(wti$Settle))
#wti <- mutate(wti, posGain = case_when(lagd1 > 3 ~ 1, TRUE ~ 0))
wti4$group = "wti"

corn = Quandl("CHRIS/CME_C1", collapse = "month", start_date=startdate, order='asc')
corn$lagd1 <- c(0,diff(corn$Settle))
corn$group = "corn"

corn4 = Quandl("CHRIS/CME_C4", collapse = "month", start_date=startdate, order='asc')
corn4$curve <- corn4$Settle - corn$Settle
corn4$group = "corn"

wti4$curve <-  wti4$Settle - wti$Settle

cc <- select(corn, Date, Settle) %>% 
  left_join(select(corn4,Date,curve, cornprice4 = Settle)) %>% 
  left_join(select(wti4,Date,oilcurve=curve, oilprice4 = Settle)) %>% 
  left_join(select(wti,Date, oilprice1 = Settle)) %>% 
  drop_na()

filter(cc, abs((oilprice1 - 60)) < 10)
cor(select(cc,Settle,oilprice1))
head(cc)
View(cc)

wti$oilpct <- round(wti$lagd1 / lag(wti$Settle),2) * 100
corn$cornpct <- round(corn$lagd1 / lag(corn$Settle),2) * 100

x <- select(wti, Date, oilpct) %>% 
  left_join(select(corn,Date,cornpct)) %>% 
  drop_na()

cor(x[,2:3])
plot(x)

p1 <- melt(x, id="Date")

ggplot(data=p1,
       aes(x=Date,y=value, colour=variable)) +
  geom_line(aes(linetype=variable)) +  
  geom_point()

tail(d1)

apply(d1[c(2,3)], 2, quantile, na.rm=TRUE)
