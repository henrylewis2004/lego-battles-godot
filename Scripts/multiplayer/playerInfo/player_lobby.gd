class_name PlayerLobby extends Control

func setReady(ready:bool) -> void:
	self.get_node("readyIcon").frame = int(ready)

func setName(name: String) -> void:
	self.get_node("playerName").text = name

func setIcon(icon:int) -> void:
	self.get_node("playerIcon").frame = icon
	
func setBackground() -> void:
	pass
	
func _init() -> void:
	self.visible = false
	
func _ready() -> void:
	self.visible = true
