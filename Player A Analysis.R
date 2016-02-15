# R Analysis - Player A

rbdata <- read.table("D:\\My Documents\\LoL Analysis Data\\rheynbeaux_history.csv", sep=",", header=T)

# I know this player primarily plays support so that's what I'm interested in this time.

rbdata2 <- rheyndata[rheyndata$Role == "DUO_SUPPORT",]

# This leaves 224 observations remaining.

rbdata2$Winner. <- as.character(rbdata2$Winner.)
rbdata2$Winner. <- replace(rbdata2$Winner., rbdata2$Winner. == 'True', '1')
rbdata2$Winner. <- replace(rbdata2$Winner., rbdata2$Winner. == 'False', '0')
rbdata2$Winner. <- as.numeric(rbdata2$Winner.)
Lost <- 1 - rbdata2$Winner.
rbdata2 <- cbind(rbdata2, Lost)

# I'm going to remove games that lasted less than twenty minutes

rbdata2 <- rbdata2[is.na(rbdata2$Creeps1020) == FALSE,]

# That only removed two observations (which is good, I was expecting it to be low)
# so there are now 222 remaining.

# I'm going to split the data into 180 observations for training the model and 42 observations for testing it.

set.seed(317)
trainnums <- sample(1:222, 180)
rbtraindata <- rbdata2[trainnums,]
rbtestdata <- rbdata2[-trainnums,]

# Let's look at two more vectors

rbdata2$Creeps010
mean(rbdata2$Creeps010)
rbdata2$Creeps1020
mean(rbdata2$Creeps1020)

# On average Player A is getting a creep score of 1 or 2 in the first ten minutes
# and an additional 3 in minutes 10 to 20.  Not per minute, just the total creeps
# across the time span.  This is so meaninglessly low it would not be wise to include
# this in the model either.

# Time to try a model

model1 <- glm(cbind(Winner., Lost) ~ DamageTaken010 + DamageTaken1020 + Gold010 + Gold1020 + SightWardsBought + TotalTimeCCDealt + VisionWardsBought + WardsKilled + WardsPlaced, data=rbtraindata, family=binomial)
summary(model1)

model2 <- update(model1, . ~ . -SightWardsBought)
summary(model2)

model3 <- update(model2, . ~ . -WardsKilled)
summary(model3)

model4 <- update(model3, . ~ . -VisionWardsBought)
summary(model4)

model5 <- update(model4, . ~ . -DamageTaken010)
summary(model5)

model6 <- update(model5, . ~ . -Gold010)
summary(model6)

model7 <- update(model6, . ~ . -TotalTimeCCDealt)
summary(model7)

testmodelstep <- step(model1) # Stepwise method matched Model 6
summary(testmodelstep)


# I'm now debating a bit between between the stepwise model and Model 7.
# I'm going to use both to predict on the test data set and see which one performs better.


# For Model 7:

result7 <- predict(model7, rbtestdata, type="response")
result7[result7 >= .5] <- 1
result7[result7 < .5] <- 0

sum(result7==rbtestdata$Winner.)

# It predicted 35 out of 42 games correctly.

sum(result7==1 & rbtestdata$Winner.==0)

sum(result7==0 & rbtestdata$Winner.==1)

# It incorrectly predicted 4 games that were actually losses and
# 3 games that were actually wins.  This is reasonably evenly spread.

sum(result7==1 & rbtestdata$Winner.==1)

sum(result7==0 & rbtestdata$Winner.==0)

# Of the correctly predicted games, 28 were wins and 7 were losses.
# But that means there were 31 wins and 11 losses in the test data by random
# chance, so that doesn't worry me.  We can calculate Cohen's Kappa to
# compensate for this.

# Actual percentage of wins = .74; predicted percentage of wins = .67.  .74*.67 = .495, and .26*.33 = .085.
# So we expect the model would be right about .44+.1 = 58% of the time by random chance.

# It matched 83% instead, so the formula for Cohen's Kappa will be:
(.83-.58)/(1-.58) # = .5952


# For the Stepwise Model:

resultstep <- predict(testmodelstep, rbtestdata, type="response")
resultstep[resultstep >= .5] <- 1
resultstep[resultstep < .5] <- 0

sum(resultstep==rbtestdata$Winner.)

# It predicted 35 out of 42 games correctly.

sum(resultstep==1 & rbtestdata$Winner.==0)

sum(resultstep==0 & rbtestdata$Winner.==1)

# It incorrectly predicted 3 games that were actually losses and
# 4 games that were actually wins.  This is reasonably evenly spread.

sum(resultstep==1 & rbtestdata$Winner.==1)

sum(resultstep==0 & rbtestdata$Winner.==0)

# Of the correctly predicted games, 27 were wins and 8 were losses.
# But that means there were 31 wins and 11 losses in the test data by random
# chance, so that doesn't worry me.  We can calculate Cohen's Kappa to
# compensate for this.

# Actual percentage of wins = .74; predicted percentage of wins = .643.  .74*.643 = .476, and .26*.357 = .093.
# So we expect the model would be right about .476+.093 = 57% of the time by random chance.

# It matched 81% instead, so the formula for Cohen's Kappa will be:
(.81-.57)/(1-.57) # = .5581


