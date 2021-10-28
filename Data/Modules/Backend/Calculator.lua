local Calculator = {} 

metDataModule = require("metData")
-- Testing a function call from metData.lua
-- metDataModule.printMetValues()

--This will be needed if we take user input as hours, minutes
function Calculator.hoursToMinutes(hours, minutes) 
  minutes = 60 * hours + minutes
  return minutes
end

function Calculator.calcCaloriesBurned(exercise, minutes, weightLbs)
  -- Floor + 0.5 rounds to the nearest integer
  -- Converts lbs input to kg
  -- Duration needs to be in minutes (subject to change)
  roundedCalories = math.floor((((metDataModule.getMetValue(exercise) * 3.5 * (weightLbs * 0.453592 )  / 200 ) * minutes) + 0.5))
  print("Calories burned: " .. roundedCalories)

end

Calculator.calcCaloriesBurned("jump rope", 80, 143.3)

return Calculator
