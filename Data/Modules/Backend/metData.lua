local metData = {}

metData.metTable = {
	["bicycling"] = 7.5,   
	["jump rope"] = 12.3,  
	["running"] = 8.0,   
	["walking"] = 3.5,   
	["tennis"] = 7.3,  
	["swimming"] = 6.0,   
	["soccer"] = 7.0    
}

function metData.getMetValue(exercise)
	return metData.metTable[exercise]
end

function metData.printMetValues() 
	for key, value in pairs(metData.metTable)	 do
		print(key,value)
	end
end

return metData
