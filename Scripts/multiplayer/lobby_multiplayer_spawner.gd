class_name LobbyMultiplayerSpawner extends MultiplayerSpawner

@export var player_lobby: PackedScene

signal playerInfoRecieved

func _ready() -> void:
	multiplayer.peer_connected.connect(lobby_connection)


func lobby_connection(id: int) -> void:
	if !multiplayer.is_server(): return

	var player: PlayerLobby = player_lobby.instantiate()
	player.name = str(id)
	player.setName("player")
	player.setReady(false)
	player.setIcon(randi() % 55)
	#getPlayerInfo.emit()

	#await playerInfoRecieved
	get_node(spawn_path).call_deferred("add_child", player)
	
func setupPlayerLobby(name: String, icon: int, player: PlayerLobby) -> void:
	player.setName("player")
	player.setReady(false)
	player.setIcon(0)
	
	playerInfoRecieved.emit()
