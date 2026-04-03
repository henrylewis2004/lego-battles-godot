extends Node2D

signal create_lobby(host: bool)
signal play_game(host: bool)


var allow_input: bool
var util : Util = Util.new()

enum STATES {INIT, START, GAMEMODE_SELECT, GAME_JOIN, GAME_HOST, LOBBY, SET_PLAYER_INFO}
var curState: int

@onready var animation_player = $AnimationPlayer
@onready var curState_label = $debug/curState
@onready var menuSelect = $background/menu_gameselect/MenuSelect

@onready var setPlayerInfo : SetPlayerInfo = $background/SetPlayerInfo
@onready var gameLobby : GameLobby = $background/GameLobby


func _input(event) -> void:
	if allow_input:
		match(curState):
			STATES.INIT:
				pass
			STATES.START:
				if event.is_action_released("menu_enter"):
					scene_goto(STATES.GAMEMODE_SELECT)
					
					
			STATES.GAMEMODE_SELECT:
				if event.is_action_released("menu_back"):
					scene_goto(STATES.START)
					
				else:
					menuSelect.input(event)
					#menuSelect.sendInfo()
				
			STATES.GAME_HOST:
				if event.is_action_released("menu_back"):
					scene_goto(STATES.GAMEMODE_SELECT)
					
			STATES.GAME_JOIN:
				if event.is_action_released("menu_back"):
					scene_goto(STATES.GAMEMODE_SELECT)
					
			STATES.LOBBY:
				# need to implement leaving lobby
				if event.is_action_released("menu_back"):
					# host
					if multiplayer.is_server():
						scene_goto(STATES.GAMEMODE_SELECT)
						
					# client
					else:
						scene_goto(STATES.GAMEMODE_SELECT)
						
				else:
					gameLobby.input(event)
					
			STATES.SET_PLAYER_INFO:
				#might need refactoring to use menuSelect but works 
				if !setPlayerInfo.isInputNameFocus():
					if event.is_action_released("ui_left"):
						setPlayerInfo.updateIcon(-1)
						
					elif event.is_action_released("ui_right"):
						setPlayerInfo.updateIcon(+1)
					
				if event.is_action_released("menu_enter"):
					setPlayerInfo.selection_complete()
				
				elif event.is_action_released("menu_back"):
					setPlayerInfo.selection_complete(false)
					
				if setPlayerInfo.allow_mouse:
					if event is InputEventMouseButton:
						if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
							for position_rect in setPlayerInfo.itemAreas.size():
								if util.mouseInArea(event.position, setPlayerInfo.itemAreas[position_rect]):
									setPlayerInfo.select_button(position_rect)
									if position_rect < 2:
										setPlayerInfo.updateIcon(1 if position_rect == 1 else - 1)
									else:
										setPlayerInfo.selection_complete()
									
									break
							if !util.mouseInArea(event.position, setPlayerInfo.getTextInputRect()):
								get_viewport().gui_release_focus()
				
					elif event is InputEventMouseMotion:
						for position_rect in setPlayerInfo.itemAreas.size():
							if util.mouseInArea(event.position, setPlayerInfo.itemAreas[position_rect]):
								setPlayerInfo.select_button(position_rect)
								return
						setPlayerInfo.select_button(-1)
					
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
			curState = STATES.LOBBY
			animation_player.play("menu_gamelobby")
			HighLevelNetworkHandler.start_sever()
			HighLevelNetworkHandler.register_host()
			
			gameLobby.host_join()
			allow_input = true

			#create_lobby.emit(true)
		STATES.GAME_JOIN:
			curState = STATES.LOBBY
			animation_player.play("menu_gamelobby")
			HighLevelNetworkHandler.start_client()
			
			allow_input = true
#			create_lobby.emit(true)
		
		STATES.SET_PLAYER_INFO:
			allow_input = true
			curState = STATES.SET_PLAYER_INFO
			$background/SetPlayerInfo.reset()
			animation_player.play("menu_set_player_info")

func scene_init():
	menuSelect.giveUtilFunc(util)
	scene_goto(STATES.INIT)

func _on_menu_select_item_selected(index: int) -> void:
	match(menuSelect.getMenuParent_ParentName()):
		"game_select_input":
			match(index):
				0 : 
					menuSelect.enable(false)
					scene_goto(STATES.GAME_HOST)
				
				1 : 	
					menuSelect.enable(false)
					scene_goto(STATES.GAME_JOIN)
					
				2 :
					menuSelect.enable(false)
					scene_goto(STATES.SET_PLAYER_INFO)
					
				_ : pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_init()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curState_label.text = "curState: " + str(STATES.keys()[curState])


func _on_set_player_info_send_info(name: String, icon: int) -> void:
	if name != "":
		PlayerInfo.playerName = name
	PlayerInfo.playerCard_index = icon

	var config := ConfigFile.new()
	config.set_value("player", "name", PlayerInfo.name)
	config.set_value("player", "iconIndex", PlayerInfo.playerCard_index)
	config.save(PlayerInfo.get_savePath())

	
	scene_goto(STATES.GAMEMODE_SELECT)
