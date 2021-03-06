#Predicting oil with logistic and linear regression models, needs cross validation
t1 <- filter(cw, year(Date) == 2018 | (year(Date) == 2017 & month(Date) %in% c(3)) | 
                  (year(Date) == 2016 & month(Date) %in% c(3)) | (year(Date) == 2015 & month(Date) %in% c(3)) |
                  (year(Date) == 2014 & month(Date) %in% c(3)))
t2 <- t1[1:(nrow(t1)),]
test1 <- t1[(nrow(t1)-15):nrow(t1),]

trainNeg <- filter(t2, !(lagd21.y == 0 | f6 == 0))  %>%
  mutate(pred6 = as.numeric((f6  < -1.5))) %>% #future day 6 value 
  select(pred6, curve.x, lagd21.x, lagd21.y) 
train <- filter(t2, !(lagd21.y == 0 | f6 == 0))  %>%
  mutate(pred6 = as.numeric((f6  > 1.5))) %>% #future day 6 value 
  select(pred6, curve.x, lagd21.x, lagd21.y) 

predToYesterday <- select(t1, f6, curve.x, lagd21.x, lagd21.y) 

model <- glm(pred6 ~.,family=binomial(link='logit'),data=train)
modelneg <- glm(pred6 ~.,family=binomial(link='logit'),data=trainNeg)

log.results <- predict(model, select(train, curve.x, lagd21.x, lagd21.y),type='response')
logNeg.results <- predict(modelneg, select(trainNeg, curve.x, lagd21.x, lagd21.y),type='response')

#View(train)

oilmod = lm(f6 ~ curve.x + lagd21.x + lagd21.y, data = trainlm)
#summary(oilmod)
oilLm <- predict(oilmod, predToYesterday)
log.results # gt 1.5
logNeg.results # lt -1.5
oilLm

predReal <- cbind(cw[(nrow(cw)-47):nrow(cw),], oilLm[(length(oilLm)-47):length(oilLm)])
View(predReal)
cor(predReal$f6, predReal$`oilLm[(length(oilLm) - 47):length(oilLm)]`)
