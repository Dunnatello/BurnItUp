--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Module: Item Handler
Purpose: Handles the retrieval and deletion of items.

-------------------------

]]

local itemHandler = { }

local foodRetriever = require( "Data.Modules.Backend.foodRetriever" )
local foodList = foodRetriever.getFoodList( )

function itemHandler.getServingCalories( itemInfo, servingAmount )
	
	local caloriesConsumed = itemInfo[ "Calories" ] * ( servingAmount / itemInfo[ "Serving Size" ] )
	
	return caloriesConsumed
	
end

function itemHandler.findItemIndex( itemTable, itemInfo ) -- Find Item Index within Table

	local itemIndex = nil
	
	for i = 1, #itemTable do
	
		if ( itemTable[ i ][ "Name" ] == itemInfo[ "Name" ] and itemTable[ i ][ "Amount" ] == itemInfo[ "Amount" ] ) then
		
			itemIndex = i
			break
			
		end
		
	end
	
	return itemIndex
	
end

function itemHandler.deleteItem( itemTable, selectedItem )
		
	local isSuccessful = true
	if ( selectedItem[ "Item" ] ~= nil ) then
			
		local currentList = itemTable[ selectedItem[ "Category" ] ]
		
		if ( selectedItem[ "Section" ] ~= "Exercises" ) then -- Handle Nested Lists
			
			currentList = currentList[ selectedItem[ "Section" ] ]
		
		end
		
		local itemIndex = itemHandler.findItemIndex( currentList, selectedItem[ "Item" ] )
		
		if ( itemIndex ~= nil ) then
			
			table.remove( currentList, itemIndex )
			
			isSuccessful = true
			
		end
		
	end
	
	return isSuccessful
	
end

function itemHandler.getFoodInfo( name, category )

	local foodInfo = { [ "Display Name" ] = "NOT FOUND", [ "Serving Size" ] = 1, [ "Serving Type" ] = "-", [ "Calories" ] = 0 }
	
	if ( foodList[ category ] ~= nil ) then
		
		for i = 1, #foodList[ category ] do
		
			if ( foodList[ category ][ i ][ "Display Name" ] == name ) then
			
				foodInfo = foodList[ category ][ i ]
				break
				
			end
			
		end
	
	end
	
	return foodInfo
		
end


return itemHandler