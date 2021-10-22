function calcCaloriesBurned()
  -- User selects exercise from drop down menu
  -- We need to create file with MET values for common exercises
  io.write("Enter MET value: ")
  METvalue = io.read()

  -- User will input duration in minutes
  io.write("Enter duration in minutes: ")
  duration = io.read()

  -- We either store user weight or have them input it (since it may change often)
  io.write("Enter weight in pounds: ")
  weightKg = io.read() / 2.2

  -- Flooring with + 0.5 rounds to the nearest integer
  roundedCalories = math.floor((((METvalue * 3.5 * weightKg) / 200 ) * duration) + 0.5)
  io.write("Calories burned: " .. roundedCalories)

end

calcCaloriesBurned()
