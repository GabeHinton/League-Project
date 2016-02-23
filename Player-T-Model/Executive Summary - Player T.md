# Executive Summary - Player T Model

Data was compiled for a Player T who primarily plays Top, Mid, or ADC.  Using fourteen variables, a model was built to attempt to predict whether Player T would win or lose his match.  The final model had two significant variables:

Gold1020: The average gold per minute Player T earned from minutes 10 to 20
DamageTaken1020: The average damage per minute Player T took from minutes 10 to 20

The final model was as follows:

Predicted Probability of Winning = e^{-3.0985 - 0.0016\*DamageTaken1020 + .0118\*Gold1020} / (1 + e^{-3.0985 - 0.0016\*DamageTaken1020 + .0118\*Gold1020})


We can see intuition behind this model by looking at a plot of these variables.  Blue points are wins and red points are losses.

![Player T Summary](https://github.com/GabeHinton/League-Project/blob/master/Images/Player.T.Summary.png?raw=true)


To interpret the meaning of the numbers in the model, the following graph shows how predicted probability of winning the game changes as DamageTaken1020 changes if Gold1020 is at its average value:

![Player T DamageTaken1020](https://github.com/GabeHinton/League-Project/blob/master/Images/Player.T.DamageTaken1020.png?raw=true)


If DamageTaken1020 is at its average value, the predicted probability of winning the game changes as Gold1020 changes as follows:

![Player T Gold1020](https://github.com/GabeHinton/League-Project/blob/master/Images/Player.T.Gold1020.png?raw=true)


# Conclusions and Follow Up

The model correctly predicted 2/3 of games, notably more than would be expected from lucky guesses.

Far from perfect accuracy is to be expected when trying to predict the outcome of a team game based on one player.  However it does seem these results indicate that a more accurate model that accounts for more variables should be possible.

One cannot conclude with confidence that taking less damage or earning more gold specifically lead to Player T having a higher chance of victory.  It is possible that Player T is performing other actions that lead to his victory that also have a side effect of earning him gold or taking less damage.  

Following up from here, more models could be built for other individual players to compare which variables are significant.  This would give insight into what variables may be useful in a general model for a larger group of players, and would give insight into how useful predictors may vary based on player playstyle.  Another path for following up would be to tackle models that account for variables across the whole team rather than a single player.

Ultimately, one goal of these models could be to create a tool that models wins and losses for a single player to give insight on target areas of skill development to help that player improve.  If this path is taken, more models of single players that include variables outside of the original fourteen used in this model would be useful.  These variables could include:

Gold not gained from player kills  
Gold not gained from creep kills  

Number of kills in the first ten minutes  
Number of kills in minutes ten to twenty  
Number of kills on the enemy's half of the map  

Jungle Buffs claimed  

Towers destroyed in first ten minutes  
Towers destroyed in minutes ten to twenty  
Number of minutes during which all lanes have more enemy towers destroyed than ally towers  

Dragons killed  

Rift Wardens killed  

Number of kills in first ten minutes with an assist from jungler  
Number of jungler kills in first ten minutes that the given player assisted  

And infinitely more.


There is a great deal more room to continue investing worthwhile time on this project.
