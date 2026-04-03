class_name MenuSelect extends Control

signal itemSelected(index: int)

var util: Util

@export var allow_mouse: bool = false
@export var allow_kb: bool = false

@export var menuParent: Node
@onready var inputTimer := $inputTimer
@export var additional_input : Array[Node]

var enabled: bool = false
var selectIndex: int = -1
var selectRow: int = 0
var lastItem: Node
var additional_selected: bool = false


var itemAreas: Array[Rect2]

#methods
func giveUtilFunc(utilFun: Util) -> void:
	util = utilFun
	

func getMenuParent_ParentName() -> String:
	return menuParent.get_parent().name

func _process(delta):
	var input: Vector2 = Vector2.ZERO

	if enabled:
		if allow_kb:
			input.y = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
			input.x = int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
		
		if (selectIndex < 0 && input < Vector2.ZERO) || (additional_selected && input != Vector2.ZERO):
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
				if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
					for position_rect in itemAreas.size():
						if util.mouseInArea(event.position, itemAreas[position_rect]):
							if position_rect < menuParent.get_child_count():
								setIndex(position_rect)
							else: 
								setIndex_additional(additional_input[position_rect - menuParent.get_child_count()],position_rect)

							itemSelected.emit(position_rect)
							
							break
				
			elif event is InputEventMouseMotion:
				for position_rect in itemAreas.size():
					if util.mouseInArea(event.position, itemAreas[position_rect]):
						if position_rect < menuParent.get_child_count():
							setIndex(position_rect)
							break
						setIndex_additional(additional_input[position_rect - menuParent.get_child_count()],position_rect)
						break
					else:
						deselect()
						
					



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
	
func setIndex_additional(menuItem: Node, index: int) -> void:
	if menuItem == null :
		return 
	
	if lastItem && lastItem != menuItem:
		if lastItem is Sprite2D:
			lastItem.frame -= 1
		
	if menuItem is Sprite2D && menuItem != lastItem:
			menuItem.frame += 1
			
	lastItem = menuItem
	selectIndex = index
	additional_selected = true

func deselect() -> void:
	if lastItem:
		if lastItem is Sprite2D:
			lastItem.frame -= 1
		lastItem = null
		selectIndex = -1
		additional_selected = false

func getIndex() -> int:
	return selectIndex
	

func enable(enableSelection:bool = true) -> void:
	enabled = false
	
	if allow_mouse:
		itemAreas.clear()
		
		var items: Array[Node] = menuParent.get_children()
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
					
		for item in additional_input:
			if item is Sprite2D:
				itemAreas.append(
					Rect2(
						item.position, 
						Vector2(
							(item.texture.get_width() / item.hframes), 
							item.texture.get_height() / item.vframes)
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
