class_name PlayerLobby extends Control

var playerReady: bool
var playerFaction: int
var playerTeam: int

func setDetails(icon: int, name: String, ready: bool = false):
	self.visible = false

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
	
