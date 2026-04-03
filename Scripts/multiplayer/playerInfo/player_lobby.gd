class_name PlayerLobby extends Control

#var playerIcon: int
#var playerName: String
var playerReady: bool

#func setDetails(icon: int, name: String, ready: bool = false):
	#playerIcon = icon
	#playerName = name
	#playerReady = ready

func setDetails(icon: int, name: String, ready: bool = false):
	setReady(ready)
	setName(name)
	setIcon(icon)
	
	self.visible = true

func setReady(ready:bool) -> void:
	self.get_node("readyIcon").frame = int(ready)

func setName(name: String) -> void:
	if name == "":
		name = "Player"
	
	self.get_node("playerName").text = name

func setIcon(icon:int) -> void:
	self.get_node("playerIcon").frame = icon
	
func setBackground() -> void:
	pass
	
## Engine

func _ready() -> void:
	self.visible = false
