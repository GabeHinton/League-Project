# Executive Summary - Player T Model

Data was compiled for ranked games during which Player T played Top, Mid, or ADC.  Using fourteen variables, a model was built to attempt to predict whether Player T would win or lose his match.  The final model had two significant variables:

Gold1020: The average gold per minute Player T earned from minutes 10 to 20  
DamageTaken1020: The average damage per minute Player T took from minutes 10 to 20  

The model correctly predicted 2/3 of games, notably more than would be expected from lucky guesses.  Far from perfect accuracy is to be expected when trying to predict the outcome of a team game based on one player.  However it does seem these results indicate that a more accurate model that accounts for more variables should be possible.  Thus, this analysis has led to the following questions that merit more testing to answer:  

1) Can we generalize the model for all players?  Will the same and only the same two variables be significant in models built for different players playing Top, Mid, and/or ADC?  
2) Can we generalize the model for all roles?  Will the same and only the same two variables be significant in models built for players playing as Jungle or Support?  
3) Can we support a claim that more gold and less damage taken are actually causing Player T to win?  One cannot conclude with confidence that taking less damage or earning more gold specifically lead to Player T having a higher chance of victory.  It is possible that Player T is performing other actions that lead to his victory that also have a side effect of earning him gold or taking less damage. 

Performing additional tests to find evidence to answering these questions will help validate and clarify the model.

Numerically, the final model was as follows:  

Predicted Probability of Winning = e^{-3.0985 - 0.0016\*DamageTaken1020 + .0118\*Gold1020} / (1 + e^{-3.0985 - 0.0016\*DamageTaken1020 + .0118\*Gold1020})
