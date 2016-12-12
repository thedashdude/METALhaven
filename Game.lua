local Game = {}

Room = require 'Room'
Menu = require 'Menu'
Lose = require 'Lose'
Tutorial = require 'Tutorial'
Game["Main"] = clone(Room)
Game["Menu"] = clone(Menu)
Game["Lose"] = clone(Lose)
Game["Tut"] = clone(Tutorial)


return Game