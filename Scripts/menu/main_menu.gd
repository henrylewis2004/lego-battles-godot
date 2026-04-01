extends Node2D

signal create_lobby(host: bool)
signal play_game(host: bool)

var allow_input: bool

enum STATES {INIT, START, GAMEMODE_SELECT, GAME_JOIN, GAME_HOST, LOBBY}
var curState: int

@onready var animation_player = $AnimationPlayer
@onready var curState_label = $debug/curState
@onready var menuSelect = $background/menu_gameselect/MenuSelect


func input() -> void:
	match(curState):
		STATES.INIT:
			pass
		STATES.START:
			if Input.is_action_just_pressed("menu_enter"):
				scene_goto(STATES.GAMEMODE_SELECT)
				
				
		STATES.GAMEMODE_SELECT:
			if Input.is_action_just_pressed("menu_back"):
				scene_goto(STATES.START)
			
		STATES.GAME_HOST:
			if Input.is_action_just_pressed("menu_back"):
				scene_goto(STATES.GAMEMODE_SELECT)
				
		STATES.GAME_JOIN:
			if Input.is_action_just_pressed("menu_back"):
				scene_goto(STATES.GAMEMODE_SELECT)

func scene_goto(scene: int):
	allow_input = false
	match(scene):
		STATES.INIT:
			curState = STATES.INIT
			animation_player.play("menu_init")
			#allow_input = false
			
			await animation_player.animation_finished
			scene_goto(STATES.START)
			
		STATES.START:
			curState = STATES.START
			animation_player.play("menu_start")
			allow_input = true
			
		STATES.GAMEMODE_SELECT:
			curState = STATES.GAMEMODE_SELECT
			animation_player.play("menu_gameselect")
			allow_input = true
			menuSelect.enable()

		STATES.GAME_HOST:
			curState = STATES.GAME_HOST
			animation_player.play("menu_gamelobby")
			allow_input = true

			create_lobby.emit(true)

func scene_init():
	scene_goto(STATES.INIT)

func _on_menu_select_item_selected(index: int) -> void:
	menuSelect.enable(false)
	match(menuSelect.getMenuParentName()):
		"menu_gameselect":
			if (index == 0):
				scene_goto(STATES.GAME_HOST)
			else:
				scene_goto(STATES.GAME_JOIN)
				

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_init()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if allow_input:
		input()
	curState_label.text = "curState: " + str(STATES.keys()[curState])
