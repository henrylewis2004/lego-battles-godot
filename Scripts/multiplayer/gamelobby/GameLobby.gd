class_name GameLobby extends Control

@onready var mp_LobbySpawner : Node = $MultiplayerSpawner
@onready var startButton: Button = $input/StartGameButton

var lobby_players: Dictionary[int, PlayerLobby]


func _ready() -> void:
	HighLevelNetworkHandler.updateLobby.connect(lobby_refresh)
	HighLevelNetworkHandler.hostJoin.connect(host_join)
	
	HighLevelNetworkHandler.player_joined.connect(lobby_connection)
	HighLevelNetworkHandler.player_left.connect(lobby_disconnection)

	mp_LobbySpawner.add_player_lobby.connect(update_player_lobby_connection)
	mp_LobbySpawner.remove_player_lobby.connect(update_player_lobby_disconnection)

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

func lobby_connection(id: int) -> void:
	mp_LobbySpawner.lobby_player_connection(id)
	
func lobby_disconnection(id: int) -> void:
	mp_LobbySpawner.remove_player(id)

func lobby_refresh() -> void:
	mp_LobbySpawner.clear()
	for id in HighLevelNetworkHandler.connected_players:
		mp_LobbySpawner.lobby_player_connection(id)
				
func update_player_lobby_connection(id: int, player: PlayerLobby) -> void:
	lobby_players[id] = player

func update_player_lobby_disconnection(id: int) -> void:
	lobby_players.erase(id)
	
	
@rpc("any_peer","call_local","reliable")
func ready(ready_state: bool) -> void:
	if !multiplayer.is_server(): return
	recieve_playerReadyState(multiplayer.get_remote_sender_id(), ready_state)
	update_playerReady()
	
	for playerID in lobby_players:
		if !lobby_players[playerID].ready:
			break
		lobby_ready.rpc()
		lobby_ready()

@rpc("authority","call_local", "reliable")
func recieve_playerReadyState(playerId: int, ready:bool) -> void:
	lobby_players[playerId].setReady(ready)
	
@rpc("authority","call_local", "reliable")	
func update_playerReady() -> void:
	if !multiplayer.is_server(): return
	
	for playerID in lobby_players:
		recieve_playerReadyState.rpc(playerID,lobby_players[playerID].ready)
		
@rpc("authority","call_local","reliable")
func lobby_ready() -> void:
	print("game ready!")
	pass

func _on_ready_button_button_up() -> void:
	ready.rpc_id(1)
