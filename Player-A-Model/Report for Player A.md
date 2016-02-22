#League of Legends Project - Player A Analysis
#####Gabe Hinton

Summary
=======

After creating a logistic regression model to predict whether Player T would win or lose a game of League of Legends as Top, Mid, or ADC role, this analysis was done to focus on a player who primarily plays support (called Player A) to see how similar or different a model predicting the outcomes of his games would be to that of Player T's. Thanks to Riot Games, Inc. for having a public API making data collection for this analysis possible.

A logistic model was formed starting with a long list of variables - the same as for Player T, except Creeps010 and Creeps1020 were omitted because intuitively they do not make much sense for a support. Furthermore the specific observed values for Player A's creep scores also don't make much sense for prediction because they were consistently below 5 for each ten minute chunk.

As before, there are notable limitations on this analysis. League of Legends is first and foremost a team game so any model looking at the behaviors and statistics of only one player is limited in scope. In addition, the model does not necessarily imply causation, because for example gold can be earned in a variety of ways, so one must wonder whether gold predicting a victory or loss does so because of the items Player A can purchase with the gold, or because of the actions he performed that earned him the gold put his team in a better position to win the game.  Similarly, the number of wards he places would be impacted by how long the game is, which is not accounted for in this analysis.

In addition, the observations for Player A cover a longer range of his total time as a player of League than Player T, so nothing is built into the model to account for Player A's skill continuing to increase over time, so that also becomes a lurking variable that could be considered in a future analysis.

In the end, the clear predictors of the outcome were Gold1020 and DamageTaken1020, the two variables in the final model for Player A, as well as WardsPlaced, which was a nice confirmation of intuition about the importance of map vision in a game of LoL.

In closing, perhaps aside from placing wards and disarming enemy players with crowd control abilities the first ten minutes of the game again seem to be poor predictors of the game outcome, as with Player T. One wonders though about the variables regarding gold and damage taken in minutes 10 to 20 showing up again - this may perhaps provide more evidence that these variables are just reflections of Player A and T's skills like good team fight engagement positioning and number of kills, rather than suggesting they should actively forsake other activities to get more gold and take less damage in order to win the game. Placing wards seems to clearly be an important factor in winning games to improve map vision for Player A. On the other hand, perhaps he is more likely to remember to continue placing wards in games that his team is currently winning. In short, there are some interesting conclusions, and plenty of room for further exploration and model building.

Objectives
==========

To avoid repetition, it is recommended you read the analysis of Player T first for an explanation of logistic regression and the intention of that analysis. This analysis is a follow up to that one, in that Player T primarily plays Top, Mid, and ADC, while this analysis's subject, Player A, mainly plays support. The goal is to find whether a similarly built logistic model to predict victory or loss in a game using data from a support player looks similar or very different to the model for Player T.

Data Summary
============

Player A has not played as many games as Player T, so the API was used to search for the past 360 ranked games of Player A and data was pulled for a variety of variables from each of those games. The variables are as follows:

Champion: An identification number for the character Player T chose to play as for that match  
Creeps010: The number of creeps Player T killed per minute across the first ten minutes of the match  
Creeps1020: The number of creeps Player T killed per minute from minute ten through twenty  
Creeps2030: The number of creeps Player T killed per minute from minute twenty through thirty  
DamageTaken010: The amount of damage Player T received per minute during the first ten minutes of the match  
DamageTaken1020: The amount of damage Player T received per minute from minute ten to twenty  
DamageTaken2030: The amount of damage Player T received per minute from minute twenty to thirty  
Gold010: The amount of gold Player T earned per minute during the first ten minutes of the match  
Gold1020: The amount of gold Player T earned per minute from minute ten to twenty  
Gold2030: The amount of gold Player T earned per minute from minute twenty to thirty  
Lane: The team "position" Player T played during the match  
MatchID: A number string identifying the match in Riot's API  
NeutralMinionsKilled: The number of neutral minions Player T killed throughout the game  
NeutralMinsEnemyJungle: The number of neutral minions Player T killed in enemy territory  
NeutralMinsTeamJungle: The number of neutral minions Player T killed in his own team's territory  
Role: "Solo" - mid or top lane as according to Lane; "None" - he played the "Jungle" role; "Duo\_Carry" - ADC;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"Duo\_Support" - Support  
SightWardsBought: The number of sight wards Player T bought throughout the game  
TotalTimeCCDealt: The sum of all seconds an enemy player was stuck in a "crowd control" ability by Player T  
VisionWardsBought: The number of vision wards Player T bought throughout the game  
WardsKilled: The number of enemy wards Player T destroyed throughout the game  
WardsPlaced: The number of wards of any type Player T placed throughout the game  
Winner.: 1 if Player T's team won the game, 0 otherwise  
Lost: 1 if Player T's team lost the game, 0 otherwise  

As before, certain additional variables could have been pulled from Riot's API but were deliberately omitted. While variables such as Kills, Assists, Inhibitor Kills, and Damage Dealt could each perhaps do a notable job of predicting whether Player A was the winner or loser, they are not very useful to the intent of the analysis. As a match in League of Legends nears its end, the team that ultimately wins typically gains momentum and begins to accumulate more kills, assists, and inhibitor kills than the team that loses. It seems highly likely that these variables can predict the winner, but that is because these are specifically the actions that cause a team to win in the first place. The goal of this analysis is to find player behaviors that less obviously could push a team to victory, as well as look at behavior that focuses more specifically on the early game through the API's time designations ("010", "1020", and "2030" variables.)

Champion, MatchID, Role, and Lane were all collected as a means of sorting data and were not actually included in the model. Role and Lane could certainly have been included to explore interaction effects, and there would be value in doing so in a future analysis. For a preliminary exploratory analysis, they were omitted for simplicity's sake.

Rather than omitting support and jungle observations as done with Player T, background knowledge of Player A informed that he primarily plays the support role. Therefore all roles except support were removed. As with player A, the few games that end before twenty minutes were also removed since they throw an unnecessary wrench in trying to view patterns among typical games. This left 222 observations to work with.

Finally, the data was divided into 180 observations randomly selected to be a training data set to build the model, and the remaining 42 observations served as a test data set to assess how well the model could predict outcomes.

Analysis
========

As mentioned previously, the analysis for Player T provides a more thorough background of the modeling method used. In short, the model is a logistic regression using values for the predictor variables to predict a probability of a binary response, in this case winning or losing the game.

This time there was no need for intuition in determining order of variables removed; they all fell into place rather logically. An alpha value of .05 was used again as the acceptable probability of an incorrect conclusion.

Following this procedure, the model reached was as follows:

    ## 
    ## Call:
    ## glm(formula = cbind(Winner., Lost) ~ DamageTaken1020 + Gold1020 + 
    ##     WardsPlaced, family = binomial, data = rbtraindata)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.4035  -0.8944   0.4450   0.8736   1.6604  
    ## 
    ## Coefficients:
    ##                  Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)     -4.674429   1.262221  -3.703 0.000213 ***
    ## DamageTaken1020 -0.005002   0.001436  -3.483 0.000495 ***
    ## Gold1020         0.020411   0.003928   5.197 2.03e-07 ***
    ## WardsPlaced      0.066109   0.028024   2.359 0.018322 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 245.16  on 179  degrees of freedom
    ## Residual deviance: 192.80  on 176  degrees of freedom
    ## AIC: 200.8
    ## 
    ## Number of Fisher Scoring iterations: 4

Recall that the primary output is in terms of "log-odds", which when taken as the power of mathematical *e* produces odds, the ratio of probability of success divided by probability of failure. With this in mind, the model coefficient (under the column Estimate in the table) when taken as the power of mathematical *e* produces the multiplicative change in odds for an increase of one in the corresponding variable, assuming all the other predictor variables are held at a constant value. Using all of this, we can interpret this model. For an increase of 1 damage taken per minute during minutes 10 to 20, the predicted odds that Player A will win the game are multiplied by *e^-.005 = .995*. If it increases by 10 then the odds are multiplied by .95. Increasing his average gold per minute for minutes 10 to 20 by 1 multiplies his odds of winning by *e^.0204 = 1.02*. If he increases it by 100 (meaning improves on his total gold across minutes 10 to 20 by 1000) his predicted odds of winning are multiplied by 7.69. For each individual ward he places during a match his predicted odds of winning increase by 1.07.

Next the test data set was placed into this model to see how well the model would do at predicting the 42 known outcomes. The results were as follows:

|                | Model Predicts Victory | Model Predicts a Loss |
|----------------|------------------------|-----------------------|
| Actual Victory | 28                     | 3                     |
| Actual Loss    | 4                      | 7                     |

35 out of 42 correct predictions is fantastic, and the incorrect predictions are evenly split suggesting the errors can be considered random. This seems like a highly successful model. This can be further verified by calculating a Cohen's Kappa statistic, which is meant to demonstrate how good of a job the model is at predicting the correct outcome while also penalizing for a quantity of correct guesses that would be expected from random chance. A Kappa of less than zero means it predicted less than expected from random chance, while one is perfect predictions. The details of this calculation can be seen in Player A Analysis, the R code file. The resulting statistic is K = .5952. This is satisfyingly high, and is even higher than the Cohen's Kappa associated with Player T's data.

Conclusion
==========

Our final model is as follows:

Odds of Winning the Game = *e*^{-4.67 - .005\*DamageTaken1020 + .0204\*Gold1020 + .0661\*WardsPlaced}

This model does have a notable amount of predictive power for Player A's games, and it is reassuring to see WardsPlaced included, since that seems intuitive for the support role. The reappearance of DamageTaken1020 and Gold1020 from Player T's model adds an interesting element of confirmation, but at the same time may also raise concerns that those are products of kills and assists that are more accurately a reflection of a team being in the lead. Player A can take comfort that early game mistakes can be recovered from and early game leads are not reason to be overzealous. Whether the increased amount of wards placed are causing the team to be more likely to win, or whether he is more likely to remember to place wards when his team is already winning, the conclusion remains that reminding himself to place wards continually is clearly helpful to his team.

If nothing else, this model is a notable starting point to attempt more complicated models in the future, perhaps incorporating similar variables but across all members of a team to predict the outcome, or testing variables that also account for changes based on the champion selected (called an interaction effect.) There is a great deal of potential for more detailed, complicated modeling and many possible directions from which to tackle the question. At the very least, this analysis does suggest it may be possible and thus worth the time to attempt in the future.
