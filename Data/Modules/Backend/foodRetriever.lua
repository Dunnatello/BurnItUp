--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Module: Food Retriever
Purpose: Loads all of the food items from the modules and stores them in one location.

-------------------------

]]

local foodRetriever = { }

local isInitialized = false

local food = { } -- Dictionary table of all food items

local folderLocation = "Data.Food."
local fileNames = { "BurgerKing", "CFA", "Chips", "Fruits", "McDonalds", "Pizza Hut", "Refreshments" } -- List of all file names within the specified folder location. Would have done a search through this directory, but it would have been lengthy and complicated.

local function sortAtoZ( a, b )

	return a[ "Display Name" ] < b[ "Display Name" ]
	
end

function foodRetriever.init( ) -- Initialize List (Only runs once).

	if ( isInitialized == false ) then
	
		isInitialized = true
		
		for i = 1, #fileNames do
		
			local newListModule = require( folderLocation .. fileNames[ i ] )
			
			food[ fileNames[ i ] ] = newListModule.data
			
			table.sort( food[ fileNames[ i ] ], sortAtoZ )

		end
		
		food[ "Sections" ] = fileNames
		
	end
	
end

function foodRetriever.getFoodList( ) -- Returns the list of food items and their properties.

	return food
	
end


return foodRetriever