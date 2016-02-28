#Executive Summary - Player A Model

Data was compiled for ranked games during which Player A played Support.  Using the same fourteen variables as player T,
a model was built to attempt to predict whether Player A would win or lose his match.  The final model had
three significant variables:

Gold1020: The average gold per minute Player A earned from minutes 10 to 20  
DamageTaken1020: The average damage per minute Player A took from minutes 10 to 20   
WardsPlaced: The number of wards of any type placed by Player A during the match.  

The model correctly predicted 83% of games correctly, which is even higher than Player T's model.  Curiously, two of Player A's 
three significant variables were the only two variables that were significant in Player T's model.  This discovery does help answer
one of the questions raised after the Player T analysis, perhaps the model in whole or part can be generalized to all roles.
The following questions still remain to follow up from this analysis:  

1) Can we generalize this model to Jungle?  Will Gold1020 and DamageTaken1020 appear again?  
2) Can we generalize this model for all Support players?  Will the same variables be significant?  
3) Can we support a claim that more gold and less damage taken are actually causing Player T to win? 
One cannot conclude with confidence that taking less damage or earning more gold specifically lead to Players T and A having a higher 
chance of victory. It is possible that Players T and A are performing other actions that lead to his victory that also have a side effect 
of earning him gold or taking less damage.

Performing additional tests to cover a larger number of players to find evidence to address these questions will help validate
 and clarify the models.
 
Numerically, the final model for Player A was as follows:

Predicted Probability of Winning the Game = e^{-4.67 - .005*DamageTaken1020 + .0204*Gold1020 + .0661*WardsPlaced} / (1 + e^{-4.67 - .005*DamageTaken1020 + .0204*Gold1020 + .0661*WardsPlaced})





