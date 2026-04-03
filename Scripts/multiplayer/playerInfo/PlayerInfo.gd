class_name PlayerInformation extends Node

var playerName: String 
var playerCard_index: int 

const SETTINGS_PATH: String = "user://lego-battles-godot/settings.cfg"

func get_savePath() -> String:
	return SETTINGS_PATH

func _ready() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		PlayerInfo.playerName = config.get_value("player", "name", "Player")
		PlayerInfo.playerCard_index = config.get_value("player", "iconIndex", 0)
