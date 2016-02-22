bizdata <- read.table("D:\\My Documents\\LoL Analysis Data\\**********_history.csv", header=T, sep=",")

# First I'm removing the games where he played Jungler since many of the variables I want to use aren't relevant
bizdataedit <- bizdata[bizdata$Role != 'NONE',]
bizdataedit

# He played jungler in 54 of the past 490 ranked games, leaving 436 observations.

# Now I'm removing games that lasted less than 20 minutes, and I'm going to not use the variables
# for 20-30 minutes because it is missing so often.  10-20 is not often missing so I won't
# lose much data.

bizdataedit <- bizdataedit[is.na(bizdataedit$Creeps1020) == FALSE,]
bizdataedit$Creeps1020
length(bizdataedit$Creeps1020)

# This removed 6 observations, leaving 430.

# For the sake of logistic regression, I need to record the winner in terms of a 
# binary success indicator: 1 = he won, 0 = he lost
# In addition, R assumes this is a factor so I convert it to a character
# vector and finally numeric once the numbers are in place.

bizdataedit$Winner. <- as.character(bizdataedit$Winner.)
bizdataedit$Winner. <- replace(bizdataedit$Winner., bizdataedit$Winner. == 'True', '1')
bizdataedit$Winner. <- replace(bizdataedit$Winner., bizdataedit$Winner. == 'False', '0')
bizdataedit$Winner. <- as.numeric(bizdataedit$Winner.)
Lost <- 1 - bizdataedit$Winner.
bizdataedit <- cbind(bizdataedit, Lost)

# Now I'm splitting the data into a random 330 observation training set, and a random 100 observation test set

set.seed(227)
trainnums <- sample(1:430, 330)
biztraindata <- bizdataedit[trainnums,]
biztestdata <- bizdataedit[-trainnums,]

# Trying a stepwise model and a manual p-value selection to see what models I come up with.

model1 <- glm(cbind(Winner., Lost) ~ Creeps010 + Creeps1020 + DamageTaken010 + DamageTaken1020 + Gold010 + Gold1020 + SightWardsBought + TotalTimeCCDealt + VisionWardsBought + WardsKilled + WardsPlaced, data=biztraindata, family=binomial)
summary(model1)

testmodel1 <- step(model1)
summary(testmodel1)

testmodel2 <- glm(cbind(Winner., Lost) ~ Creeps1020 + DamageTaken1020 + Gold1020 + WardsKilled + WardsPlaced, data = biztraindata, family = binomial)
summary(testmodel2)

testmodel3 <- glm(cbind(Winner., Lost) ~ DamageTaken1020 + Gold1020 + WardsKilled + WardsPlaced, data = biztraindata, family = binomial)
summary(testmodel3)

testmodel4 <- glm(cbind(Winner., Lost) ~ DamageTaken1020 + Gold1020 + WardsPlaced, data = biztraindata, family = binomial)
summary(testmodel4)

testmodel5 <- glm(cbind(Winner., Lost) ~ DamageTaken1020 + Gold1020, data = biztraindata, family = binomial)
summary(testmodel5)


# Neither is what I expected, so I brainstormed that maybe games playing as support were affecting the model, so I needed to remove the games he was support also - they're too different.

bizdataedit <- bizdataedit[bizdataedit$Role != "DUO_SUPPORT",]

# 360 games are left.  I create another test and training data set from this subset.

set.seed(312)
trainnums2 <- sample(1:360, 300)
biztraindata2 <- bizdataedit[trainnums2,]
biztestdata2 <- bizdataedit[-trainnums2,]
newmodel1 <- glm(cbind(Winner., Lost) ~ Creeps010 + Creeps1020 + DamageTaken010 + DamageTaken1020 + Gold010 + Gold1020 + SightWardsBought + TotalTimeCCDealt + VisionWardsBought + WardsKilled + WardsPlaced, data=biztraindata2, family=binomial)
summary(newmodel1)

newmodel2 <- glm(cbind(Winner., Lost) ~ Creeps010 + Creeps1020 + DamageTaken010 + DamageTaken1020 + Gold010 + Gold1020 + SightWardsBought + VisionWardsBought + WardsKilled + WardsPlaced, data=biztraindata2, family=binomial)
summary(newmodel2)

newmodel3 <- glm(cbind(Winner., Lost) ~ Creeps010 + Creeps1020 + DamageTaken010 + DamageTaken1020 + Gold010 + Gold1020 + SightWardsBought + WardsKilled + WardsPlaced, data=biztraindata2, family=binomial)
summary(newmodel3) 

newmodel4 <-  glm(cbind(Winner., Lost) ~ Creeps010 + Creeps1020 + DamageTaken010 + DamageTaken1020 + Gold010 + Gold1020 + SightWardsBought + WardsPlaced, data=biztraindata2, family=binomial)
summary(newmodel4)

newmodel5 <-   glm(cbind(Winner., Lost) ~ Creeps1020 + DamageTaken010 + DamageTaken1020 + Gold010 + Gold1020 + SightWardsBought + WardsPlaced, data=biztraindata2, family=binomial)
summary(newmodel5)

newmodel6 <- glm(cbind(Winner., Lost) ~ Creeps1020 + DamageTaken010 + DamageTaken1020 + Gold1020 + SightWardsBought + WardsPlaced, data=biztraindata2, family=binomial)
summary(newmodel6)

newmodel7 <- glm(cbind(Winner., Lost) ~ Creeps1020 + DamageTaken1020 + Gold1020 + SightWardsBought + WardsPlaced, data=biztraindata2, family=binomial)
summary(newmodel7)

newmodel8 <- glm(cbind(Winner., Lost) ~ Creeps1020 + DamageTaken1020 + Gold1020 + WardsPlaced, data=biztraindata2, family=binomial)
summary(newmodel8)

newmodel9 <- glm(cbind(Winner., Lost) ~ Creeps1020 + DamageTaken1020 + Gold1020, data=biztraindata2, family=binomial)
summary(newmodel9)

newmodel10 <- glm(cbind(Winner., Lost) ~ DamageTaken1020 + Gold1020, data=biztraindata2, family=binomial)
summary(newmodel10)

# Surprisingly similar to the previous models. I better leave it here then.

# Time to use the model to predict with the training data and see how accurate it is.

result2 <- predict(newmodel10, biztestdata2, type="response")
result2[result2 >= .5] <- 1
result2[result2 < .5] <- 0

cbind(result2, biztestdata2$Winner., result2==biztestdata2$Winner.)
sum(result2==biztestdata2$Winner.)

# It predicted 40 out of the 60 games correctly.

sum(result2==1 & biztestdata2$Winner.==0)

sum(result2==0 & biztestdata2$Winner.==1)

# It predicted 10 losses as wins, and 10 wins as losses, which is great in one sense - we want the errors to be random, and now it seems that they are.

# We can calculate a Cohen's Kappa statistic to assess whether the model is truly predicting beyond random chance.

sum(biztestdata2$Winner. == 1)

sum(result2 == 1)

# Actual percentage of wins = .55; predicted percentage of wins = .55.  .55*.55=.3025, and .45*.45=.2025.
# So we expect the model would be right about .3025+.2025 = 50.5% of the time by random chance.

# It matched 66.7% instead, so the formula for Cohen's Kappa will be:
(.667-.505)/(1-.505) # =.327

# This is a decent Cohen's Kappa, confirming that the model is correctly predicting beyond random chance
# because .327 > 0.  It isn't predicting remarkably consistently but we can discuss that in the conclusion.
