class_name PlayerInformation extends Node

var playerName: String 
var playerCard_index: int = 0


	
func setPlayerName(name: String) -> void:
	playerName = name
	
func setPlayerCardIndex(index: int) -> void:
	playerCard_index = index
	
func setPlayerInfo(name: String, index: int) -> void:
	setPlayerName(name)
	setPlayerCardIndex(index)
