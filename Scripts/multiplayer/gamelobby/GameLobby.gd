class_name GameLobby extends Control

@onready var mp_LobbySpawner : LobbyMultiplayerSpawner = $MultiplayerSpawner
@onready var startButton: Button = $input/StartGameButton

var players: Dictionary[int, PlayerLobby]

func createStartButton() -> void:
	if !multiplayer.is_server(): return
	
	enableStartButton(false)
	startButton.visible = true
	
func enableStartButton(enabled: bool) -> void:
	startButton.disabled = !enabled

func host_join() -> void:
	if !multiplayer.is_server(): return
	createStartButton()

func clear_lobby() -> void:
	mp_LobbySpawner.clear()

func lobby_connection() -> void:
	mp_LobbySpawner.clear()
	for id in HighLevelNetworkHandler.connected_players:
		mp_LobbySpawner.lobby_player_connection(id)
	return


func _ready() -> void:
	HighLevelNetworkHandler.updateLobby.connect(lobby_connection)
	HighLevelNetworkHandler.hostJoin.connect(host_join)
	
@rpc("any_peer","call_local","reliable")
func ready() -> void:
	if !multiplayer.is_server(): return
	
	print(str(multiplayer.get_remote_sender_id()) + " is ready!")

func _on_ready_button_button_up() -> void:
	ready.rpc_id(1)
