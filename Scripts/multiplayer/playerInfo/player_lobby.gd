class_name PlayerLobby extends Control

var playerIcon: int
var playerName: String
var playerReady: bool

func setDetails(icon: int, name: String, ready: bool = false):
	playerIcon = icon
	playerName = name
	playerReady = ready

func setReady(ready:bool = playerReady) -> void:
	self.get_node("readyIcon").frame = int(ready)

func setName(name: String = playerName) -> void:
	self.get_node("playerName").text = name

func setIcon(icon:int = playerIcon) -> void:
	self.get_node("playerIcon").frame = icon
	
func setBackground() -> void:
	pass
	

func _ready() -> void:
	self.visible = false
	setReady()
	setName()
	setIcon()
	self.visible = true
