--[[ (To Chase) The values below were picked based on the MET values you gave me from
     the study "Metabolic Equivalents (METS) in Exercise Testing, Exercise Prescription,
	and Evaluation of Functional Capacity".  If it had a value like "5-7", I just picked the average
	.The function "acquireMetValue" allows access outside this file.  This table will be
	expanded in the future.]]--

local metTable = {
	[1] = 4.4 --digging (gardening)
	[2] = 3.5 --raking (gardening)
	[3] = 3.5 --weeding (gardening)
	
	[4] = 6.0 --capentry (heavy housework)
	[5] = 4.5 --grocery shopping (heavy housework)

	--[[This could also be done with the indexes being the names of the exercises,
		but I figured it would be better to have integer indexes since we'll be
		using a drop down, so the program itself would just use int values.]]--
}

function acquireMetValue(index)
	
	return metTable[index]
	
end