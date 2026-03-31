class_name MenuSelect extends Control

signal itemSelected(index: int)

@export var menuParent: Node
@onready var inputTimer := $inputTimer

var enabled: bool = false
var selectIndex: int = 0
var lastItem: Node

#methods
func getMenuParentName() -> String:
	return menuParent.get_parent().name

func _process(delta):
	var input: Vector2 = Vector2.ZERO

	if enabled:
		input.y = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
		input.x = int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
		
		match (menuParent.get_class()):
			"VBoxContainer":
				setIndex(selectIndex + input.y)
			"HBoxContainer":
				setIndex(selectIndex + input.x)
			"GridContainer":
				setIndex(selectIndex + input.y + input.x * menuParent.columns)
		
		if Input.is_action_just_pressed("ui_accept"):
			itemSelected.emit(selectIndex)
			

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
	
	
	if lastItem:
		if lastItem is Sprite2D:
			lastItem.frame -= 1
		
	lastItem = menuItem
	if lastItem is Sprite2D:
			lastItem.frame += 1
	
	selectIndex = index

func getIndex() -> int:
	return selectIndex
	

func enable(enableSelection:bool = true) -> void:
	enabled = false

	if enableSelection:
		setIndex(0)
		inputTimer.start()
		
func setMenu(node: Node) -> void:
	menuParent = node
	
func _on_input_timer_timeout():
	enabled = true
