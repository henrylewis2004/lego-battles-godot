class_name GameLobby extends Control

@onready var mp_LobbySpawner : LobbyMultiplayerSpawner = $MultiplayerSpawner

var players: Dictionary[int, PlayerLobby]

func clear_lobby() -> void:
	pass

func _ready() -> void:
	HighLevelNetworkHandler.updateLobby.connect(lobby_connection)
#	multiplayer.peer_connected.connect(lobby_connection)

func lobby_connection() -> void:
	print("here")
	mp_LobbySpawner.clear()
	for id in HighLevelNetworkHandler.connected_players:
		mp_LobbySpawner.lobby_player_connection(id)
	
