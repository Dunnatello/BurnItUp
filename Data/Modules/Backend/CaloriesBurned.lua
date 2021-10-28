metDataModule = require("metData")

-- Testing a function call from metData.lua
metDataModule.printMetValues()

function calcCaloriesBurned()
  -- This will eventually call getMetValue() when user selects an exercise
  print("Enter MET value: ")
  METvalue = io.read()

  -- User will input duration in minutes
  print("Enter duration in minutes: ")
  duration = io.read()

  -- We either store user weight or have them input it (since it may change often)
  print("Enter weight in pounds: ")
  weightKg = io.read() / 2.2

  -- Flooring with + 0.5 rounds to the nearest integer
  roundedCalories = math.floor((((METvalue * 3.5 * weightKg) / 200 ) * duration) + 0.5)
  print("Calories burned: " .. roundedCalories)

end

calcCaloriesBurned()

