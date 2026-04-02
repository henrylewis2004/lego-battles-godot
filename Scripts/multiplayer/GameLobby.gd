class_name GameLobby extends Control

@onready var mp_LobbySpawner : LobbyMultiplayerSpawner = $MultiplayerSpawner

var players: Dictionary[int, PlayerLobby]


func _ready() -> void:
	multiplayer.peer_connected.connect(lobby_connection)

func lobby_connection(id: int) -> void:
	HighLevelNetworkHandler.register_player.rpc_id(1,id,PlayerInfo)
	
	mp_LobbySpawner.lobby_player_connection(id)
