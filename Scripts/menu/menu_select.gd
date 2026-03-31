class_name MenuSelect extends Control

signal itemSelected(index: int)

@export var menuParent: Node
@export var allow_mouse: bool = false
@export var bonus_area: Vector2
@onready var inputTimer := $inputTimer

var enabled: bool = false
var selectIndex: int = -1
var lastItem: Node


var itemAreas: Array[Rect2]

#methods
func getMenuParentName() -> String:
	return menuParent.get_parent().name

func _process(delta):
	var input: Vector2 = Vector2.ZERO

	if enabled:
		input.y = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
		input.x = int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
		
		if selectIndex < 0 && input < Vector2.ZERO:
			selectIndex = 0
		
		match (menuParent.get_class()):
			"VBoxContainer":
				setIndex(selectIndex + input.y)
			"HBoxContainer":
				setIndex(selectIndex + input.x)
			"GridContainer":
				setIndex(selectIndex + input.y + input.x * menuParent.columns)
		
		if Input.is_action_just_pressed("ui_accept"):
			itemSelected.emit(selectIndex)

func _input(event):
	if enabled:
		if allow_mouse: 
			if event is InputEventMouseButton:
				match(event.button_index):
					MOUSE_BUTTON_LEFT:
						for position_rect in itemAreas.size():
							if mouseInArea(event.position, itemAreas[position_rect]):
								itemSelected.emit(position_rect)
								break
				
			elif event is InputEventMouseMotion:
				for position_rect in itemAreas.size():
					if mouseInArea(event.position, itemAreas[position_rect]):
						setIndex(position_rect)
						break
					else:
						deselect()
						
					

			
func mouseInArea(mouse_position: Vector2, area: Rect2) -> bool:
	if ( (mouse_position.x >= area.position.x - bonus_area.x && mouse_position.x <= area.position.x + area.size.x + bonus_area.x)
	&& (mouse_position.y >= area.position.y - bonus_area.y && mouse_position.y <= area.position.y + area.size.y + bonus_area.y) ):
		return true
	return false


func getMenuItem(index: int) -> Node:
	if menuParent == null:
		return null
	
	if index >= menuParent.get_child_count() || index < 0:
		return null
	
	return menuParent.get_child(index)

func setIndex(index: int) -> void:
	var menuItem := getMenuItem(index)

	if menuItem == null :
		return 
	
	if menuItem.visible == false:
		setIndex(index + 1 if index > 0 else index - 1)
		return
	
	
	if lastItem && lastItem != menuItem:
		if lastItem is Sprite2D:
			lastItem.frame -= 1
		
	
	if menuItem is Sprite2D && menuItem != lastItem:
			menuItem.frame += 1
			
	lastItem = menuItem
	selectIndex = index

func deselect() -> void:
	if lastItem:
		if lastItem is Sprite2D:
			lastItem.frame -= 1
		lastItem = null
		selectIndex = -1

func getIndex() -> int:
	return selectIndex
	

func enable(enableSelection:bool = true) -> void:
	enabled = false
	
	if allow_mouse:
		itemAreas.clear()
		
		var items: Array[Node] = menuParent.get_children()
		for child in items.size():
			if items[child] is Sprite2D:
				itemAreas.append(
					Rect2(
						items[child].position, 
						Vector2(
							(items[child].texture.get_width() / items[child].hframes), 
							items[child].texture.get_height() / items[child].vframes)
							)
					)


	if enableSelection:
		if !allow_mouse:
			setIndex(0)
		inputTimer.start()
		
func setMenu(node: Node) -> void:
	menuParent = node
	
func _on_input_timer_timeout():
	enabled = true
