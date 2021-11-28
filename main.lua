--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Scene: Main
Purpose: Starting point of the Solar2D project.

-------------------------

]]

local composer = require( "composer" ) -- Retrieve the scene handler.

-- Initialize Food List
local foodRetriever = require( "Data.Modules.Backend.foodRetriever" )
foodRetriever.init( )

display.setDefault( "background", 245 / 255, 245 / 255, 245 / 255 )

composer.gotoScene( "Data.Scenes.Splash" ) -- Go to the Splash scene.


