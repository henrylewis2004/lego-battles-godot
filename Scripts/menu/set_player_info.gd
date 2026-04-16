class_name SetPlayerInfo extends Node

signal send_info(name: String, icon: int)

@onready var playerIcon: AnimatedSprite2D = $playerIcon
@onready var input_buttons: Control = $input
@onready var input_name: LineEdit = $LineEdit

@export var allow_mouse: bool = true#might need changing
var itemAreas: Array[Rect2]
const DEFAULT_NAME: String = "Player"

func getTextInputRect() -> Rect2:
	return Rect2(input_name.position, input_name.get_theme_stylebox("normal").texture.get_size())

func isInputNameFocus() -> bool:
	return input_name.has_focus()

func updateIcon(index: int) -> void:
	index = playerIcon.frame + index
	
	if (index < 0):
		index = playerIcon.sprite_frames.get_frame_count("playerCard") - 1
	elif (index > playerIcon.sprite_frames.get_frame_count("playerCard") - 1):
		index = 0

	print(index)
		
	playerIcon.frame = index

func select_button(button: int) -> void:
	match(button):
		-1:
			input_buttons.get_node("arrows/Larrow").frame = 0
			input_buttons.get_node("arrows/Rarrow").frame = 0
			input_buttons.get_node("accept").frame = 0
		0:
			input_buttons.get_node("arrows/Larrow").frame = 1
			
			input_buttons.get_node("arrows/Rarrow").frame = 0
			input_buttons.get_node("accept").frame = 0
			
		1:
			input_buttons.get_node("arrows/Rarrow").frame = 1
			
			input_buttons.get_node("arrows/Larrow").frame = 0
			input_buttons.get_node("accept").frame = 0
		2:
			input_buttons.get_node("accept").frame = 1
			
			input_buttons.get_node("arrows/Rarrow").frame = 0
			input_buttons.get_node("arrows/Larrow").frame = 0
			



func selection_complete(updateName: bool = true) -> void:
	send_info.emit(input_name.text.strip_edges() if updateName else "", playerIcon.frame)

func reset() -> void:
	var playerName: String = PlayerInfo.playerName
	if playerName != "":
		input_name.text = playerName
	updateIcon(PlayerInfo.playerCard_index)
		
func _ready() -> void:
	reset()
	
	if allow_mouse:
		itemAreas.clear()
		
		var items: Array[Node] = input_buttons.get_children()
		for child in items:
			
			if child is Sprite2D:
				itemAreas.append(
					Rect2(
						child.position, 
						Vector2(
							(child.texture.get_width() / child.hframes), 
							child.texture.get_height() / child.vframes)
							)
					)
			elif child is Container:
				for grandchild in child.get_children():
					if grandchild is Sprite2D:
						itemAreas.append(
							Rect2(
								grandchild.position - (Vector2(grandchild.texture.get_size().x / grandchild.hframes,grandchild.texture.get_size().y / grandchild.vframes )) * grandchild.scale if grandchild.rotation_degrees==180 else grandchild.position, 
								Vector2(
									(grandchild.texture.get_width() * grandchild.scale.x / grandchild.hframes), 
									grandchild.texture.get_height() * grandchild.scale.y / grandchild.vframes)
									)
							)
