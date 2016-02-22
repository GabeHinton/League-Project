#League of Legends Project - Report for Player T
#####Gabe Hinton

Summary
-------

Using Riot Games, Inc.'s public API a match history of 490 ranked games was pulled for a player referred to as Player T. For each of these games a number of variables were collected related to the player's behavior and actions during the game. A logistic regression was performed to explore whether any of these behaviors and actions, with an emphasis on behaviors during the early phases of the game, seemed to be closely related to eventually winning or losing the game.  Long term, the goal of finding such models is to see if they can be generalized to fit more players, expand the models to account for more lurking variables, expand them to account for multiple players on a team, and ultimately to use them as a tool to help players identify areas of focus for improvement in their playing.

Observations of games in which Player T was the Jungle or Support role were removed because the nature of those roles is so distinct from Top, Mid, and ADC that they would likely need a unique list of variables to have reasonable predictions.

It is important to also note the limits of this analysis from the outset, for example noting that League of Legends is first and foremost a team game, so problems immediately arise from trying to predict the outcome of the game looking at only one player on that team.  In addition, it is difficult to claim causation from this analysis when a variable like gold, for example, could be increasing as a result of variables that were not considered, like number of kills.  

A logistic model was successfully made on a training data set of 300 observations. Surprisingly, the only significantly related variables to victory or loss were gold earned per minute from minutes ten to twenty and damage taken per minute from minutes ten to twenty.  The model built was as follows:

Predicted Probability of Winning = e^{-3.0985 - 0.0016\*DamageTaken1020 + .0118\*Gold1020} / (1 + e^{-3.0985 - 0.0016\*DamageTaken1020 + .0118\*Gold1020})

Using a test data set of 60 observations, a Cohen's Kappa statistic was calculated to determine whether the model was predicting the outcome of the 60 games accurately beyond random chance. Cohen's Kappa was .327. It was predicting outcomes with more accuracy than would happen from normal chance, but not remarkably so. Gold earned per minute from minute ten to twenty and damage taken per minute from minute ten to twenty definitely have a relationship with victory, but it is not strong.

Perhaps most interestingly, variables from minutes zero to ten of a match were not very related to victory at all. This suggests that Player T's early game performance does not have a strong impact on the outcome of the game, meaning he has room to make a comeback from a poor start, and should also avoid getting overzealous from an early lead.


Objectives
----------

League of Legends is a Player versus Player online game created by Riot Games, Inc. in which two teams of five compete against each other to destroy towers and ultimately each other's bases. Riot has a public API from which anyone is allowed to pull data, typically for software developers who want to create apps all players can use to find statistics about champions or basic details about their own performance. Additionally, the API can be searched by player name, including a history of game matches. This match history typically also contains very detailed information for each player in the game, and for some categories even breaks the numbers down into ten minute chunks of the game. This analysis attempts to use that data to see whether a specific player's behavior and actions in the game, with an emphasis on the early phases of the game, can be modeled to reliably predict whether that player will win.  

Data Summary
------------

The API was used to search for the past 490 ranked games of a specific player (referred to as Player T,) and data was pulled for a variety of variables from each of those 490 games. The variables are as follows:

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

Certain additional variables could have been pulled from Riot's API but were deliberately omitted. While variables such as Kills, Assists, Inhibitor Kills, and Damage Dealt could each perhaps do a notable job of predicting whether Player T was the winner or loser, they are not very useful to the intent of the analysis. As a match in League of Legends nears its end, the team that ultimately wins typically gains momentum and begins to accumulate more kills, assists, and inhibitor kills than the team that loses. It seems highly likely that these variables can predict the winner, but that is because these are specifically the actions that cause a team to win in the first place. The goal of this analysis is to find player behaviors that less obviously could push a team to victory, as well as look at behavior that focuses more specifically on the early game through the API's time designations ("010", "1020", and "2030" variables.)

Originally this list of variables were chosen to provide a varied data set, but when setting out to begin a logical analysis, several variables were eliminated immediately. The Jungler role - designated "None" under Role - plays so differently from other positions that it was deemed to need a separate model. All three Creeps variables barely apply, and Jungler is the only role to which NeutralMinion variables apply in any meaningful way. With all this in mind, the NeutralMinion variables were omitted, and all observations from games in which Player T played the Jungler role were also omitted, leaving 436 observations. In addition, in League of Legends a team can forfeit once the game has lasted twenty minutes, which happens fairly frequently. This means all variables ending in 2030 had very many missing values. Deciding the timed variables can just focus on the early portions of the game, all 2030 variables were omitted from analysis. Six of the 436 games also ended before twenty minutes had passed and thus were also missing the 1020 variables, so these six games were omitted from analysis because our sample size was still plenty large, and having observations where the game ended before twenty minutes won't give us much information about typical player behavior.

Champion, MatchID, Role, and Lane were all collected as a means of sorting data and were not actually included in the model. Role and Lane could certainly have been included to explore interaction effects, and there would be value in doing so in a future analysis. For a preliminary exploratory analysis, they were omitted for simplicity's sake.

Analysis
--------

Logistic regression will be the model used for this analysis. When the response variable consists of two values, success and failure (corresponding to wins and losses in this situation), this is called a binomial response. A typical linear regression model is not appropriate for a binomial response because in a linear model if extremely high or low values of the predictor are chosen your response could theoretically be from negative to positive infinity. A useful model here would output 1 for a game Player T is like to win and 0 for a game Player T is likely to lose. A logistic regression accomplishes this - it's output will not literally be interpretible because it is called "log-odds" but it can easily and consistently be transformed into a decimal between 0 and 1 representing a probability that Player T will win the game according to the model.

The model will begin with all of the remaining variables after the discussion in the Data Summary section, and these variables will be eliminated manually using a standard of alpha = .05 to designate variables as insignificant - that is, if a variable has a p-value less than .05 it will be considered significant. In most cases at each step of the modeling process the variable with the highest p-value was removed, but in a few cases a variable with a slightly lower p-value was removed instead in favor of keeping a variable that seemed more intuitive to be a predictor. However, ultimately those variables were still removed so this procedure had little impact on the final result.

Following this procedure, the first attempt at a model was as follows:

    ## 
    ## Call:
    ## glm(formula = cbind(Winner., Lost) ~ DamageTaken1020 + Gold1020, 
    ##     family = binomial, data = biztraindata)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.1941  -1.0034   0.5252   0.9237   1.8273  
    ## 
    ## Coefficients:
    ##                   Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)     -2.3775643  0.7360210  -3.230 0.001237 ** 
    ## DamageTaken1020 -0.0021430  0.0006388  -3.355 0.000794 ***
    ## Gold1020         0.0111569  0.0018478   6.038 1.56e-09 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 451.59  on 329  degrees of freedom
    ## Residual deviance: 386.85  on 327  degrees of freedom
    ## AIC: 392.85
    ## 
    ## Number of Fisher Scoring iterations: 4

Surprisingly, almost all variables were not significant in predicting whether Player T would win or lose the game he was playing. Only two were: DamageTaken1020 and Gold1020.

This result was a bit disappointing - these two variables have similar issues as Kills and Assists would, that as a team gains momentum the damage they take will decrease and the gold they gain will increase dramatically, so there is a legitimate concern that it cannot be used to predict a win so much as it is being used to predict whether a team has already done what it needs to do to be getting close to winning.

Knowing that this analysis is ultimately informal because of perhaps infinite lurking variables, I continued brainstorming and eventually realized that, much like Jungler, Support also has a highly unique playstyle and would have very different values for most of these variables than the more "typical" roles often called "Top", "Mid", and "ADC." So modeling was attempted again, this time removing all games in which Player T played the support role, this time leaving 360 observations remaining. This time, also interested in an assessment of the accuracy of the model's predictive power, the data was split into a training and test set. 300 observations were randomly selected to train the model, and the remaining 60 observations were set aside to assess how accruately the model would predict whether the 60 games were wins or losses.

The procedure for selecting variables was the same as before, and the final model was as follows:

    ## 
    ## Call:
    ## glm(formula = cbind(Winner., Lost) ~ DamageTaken1020 + Gold1020, 
    ##     family = binomial, data = biztraindata2)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.2003  -0.9837   0.4908   0.9559   1.9053  
    ## 
    ## Coefficients:
    ##                   Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)     -3.0985030  0.7928645  -3.908 9.31e-05 ***
    ## DamageTaken1020 -0.0016186  0.0006565  -2.466   0.0137 *  
    ## Gold1020         0.0118372  0.0019267   6.144 8.05e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 412.47  on 299  degrees of freedom
    ## Residual deviance: 351.13  on 297  degrees of freedom
    ## AIC: 357.13
    ## 
    ## Number of Fisher Scoring iterations: 4

Surprisingly, the exact same variables were left significant as before, with only slight changes to the coefficients.  If the data of these variables is plotted, this seems reasonably intuitive.  

![]()

Blue points are games that Player T won, and red points are games he lost.  We can see a trend that more wins (blue points) are found as we go further down and to the right on the plot, exactly as we expect. (Remember that smaller values of Damage Taken are preferred.) There are exceptions at the extremes, and more of a mix of points around the middle of the plot, which is also expected.  There are a multitude of variables not considered in the analysis, so we do not expect to be able to predict perfectly and account for all variation.

To interpret the model, note that the coefficients are the multiplied factor by which "log-odds" will change for a unit increase in the corresponding variable. Thus the model is:

Log-odds =  -3.0985 - 0.0016\*DamageTaken1020 + .0118\*Gold1010

We can convert log-odds to odds by simply taking *e^{estimate}* where *estimate* is the number in the Estimate column of the table. Note that odds and probability of winning are not exactly the same thing. Odds are the ratio of {Probability of Success} divided by {Probability of Failure}.  

Thus, specifically, for each increase of one damage taken per minute from minutes ten to twenty in the game - or ten total damage taken from minutes ten to twenty - Player T's odds of winning will be multiplied by *e^{-.00162} = .998*.  We can interpret this as probability with a bit more math.  Probability = Odds / (1 + Odds).  If we plug in the mean of Gold1020 into the formula and calculate the result at each point on the range of DamageTaken1020, we can graph how the predicted probability of winning changes as DamageTaken1020 changes.

![]()

Again, note that this graph is only specific to when Gold1020 is at its average level.  The general trend will be similar for most values, however.

For every ten gold earned from minutes ten to twenty in the game, Player T's odds of winning will be multiplied by *e^{.0118} = 1.012*. Put into perhaps a more interesting and relatable interpretation, if Player T earns an additional 1000 gold during minutes ten to twenty of the game, his odds (not probability, remember) of winning are predicted to be multiplied by *e^{1.184} = 3.267*, which is a much more notable increase, with 1000 gold still being a very attainable goal.  This time, by plugging in DamageTaken1020 at its mean value we can plot how the predicted probability of winning changes as Gold1020 changes.

![]()


At this point it is worthwhile to note that a model suggesting a relationship between these variables is not in itself sufficient to suggest that having more gold and taking less damage directly cause Player T to be more likely to win. There are plenty of other difficult to quantify variables at play in a PvP game, and as already mentioned gold and damage taken could also just be the result (much like victory or loss themselves) of other player behaviors that also happen to cause the player to be more or less likely to win the game. Care must be taken to not assume that the results are as simple as earning more gold in a game directly causing Player T to be more likely to win. For example, maybe Player T has more gold because he killed more enemy players, which is also putting is team in a map position to take objectives and ultimately destroy the enemy base. The gold itself might not be what helps Player T win - it could be a side effect of the unknown behaviors that actually help Player T's team win.

Moving forward, this exact model was used to calculate probability of Player T winning a game based on the Gold1020 and DamageTaken1020 variables from the 60 observation test data set. The responses were transformed into a probability of winning the game, and then probabilies greater than .5 were considered to be predicting victory and less than .5 were considered to be predicting a loss. Then the model's prediction and the actual result were compared. The table below shows the results:

|                | Model Predicts Victory | Model Predicts a Loss |
|----------------|------------------------|-----------------------|
| Actual Victory | 23                     | 10                    |
| Actual Loss    | 10                     | 17                    |

The first thing to note is that of the games the model predicted incorrectly, exactly half were wins and half were losses. This means the errors appear to be truly random, which is one of the assumptions of an effective model. It only predicted two-thirds of the games correctly, but with so few variables this is not so surprising - it is clear that while there is a trend of relationships between these variables it is far from perfect.

To quantify a bit more reliably, rather than simply concluding the model was accurate 66.7% of the time, the Cohen's Kappa statistic will be used. This statistic is intended to reflect the accuracy of model predictions but give a penalty to the result based on how often the model would be expected to predict correctly based on chance, specifically based on proportions in the data set in question. Cohen's Kappa less than zero means the model predicted worse than we would expect from chance, and greater than zero means better than we expect from chance, with 1 being perfect predictions. Details of the Cohen's Kappa calculaton can be found in the R Code file, and the resulting Kappa was .327. Clearly the model is predicting better than chance, but again the relationship is not perfect and the accuracy of predictions is still limited.

Conclusion
----------

Looking at the gold earned and damage taken of one of Player T's League of Legends matches can give a prediction of whether Player T will win or lose more often than just guessing from random chance. The model created to do so is as follows:

Predicted Probability of Winning = e^{-3.0985 - 0.0016\*DamageTaken1020 + .0118\*Gold1020} / (1 + e^{-3.0985 - 0.0016\*DamageTaken1020 + .0118\*Gold1020})

However, it does not increase the accuracy of predictions by a remarkable amount, so while a relationship between gold earned and damage taken in minutes ten to twenty of a game and the outcome of the game does exist, it is not a very strong relationship. Unfortunately we cannot also conclude that deliberately increasing gold earned or decreasing damage taken will also directly result in Player T being more likely to win, although in context this is certainly intuitive, so it is not out of the question.

Also, it must be recognized that League of Legends is primarily a team game, so there are innate limitations to looking at the behavior of only one player in the game when predicting the outcome.

Perhaps most interestingly, the variables related to the first ten minutes of the game did not help predict the outcome of the game at all. While it is likely an extremely poor or successful early phase of the game would make victory more or less likely, the model does suggest that generally early game performance is not very related to the eventual outcome. Player T can take heart that a comeback is possible after the first ten minutes, and additionally should be careful to not be overzealous just because of an early lead.
