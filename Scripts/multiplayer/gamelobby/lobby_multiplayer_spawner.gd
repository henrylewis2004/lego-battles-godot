class_name LobbyMultiplayerSpawner extends Node

signal add_player_lobby(id: int, PlayerLobby)
signal remove_player_lobby(id: int)

@export var player_lobby: PackedScene
@export var spawn_path: NodePath

## Player Lobby getters

func get_playerLobby(id: int) -> PlayerLobby:
	return get_node(spawn_path).get_child(id)

func get_PlayerLobbyDict() -> Dictionary[int,PlayerLobby]:
	var players := get_node(spawn_path).get_children()
	var res : Dictionary[int, PlayerLobby]
	for player in players:
		res[int(player.name)] = player
	return res
	
## lobby methods

func clear() -> void:
	for player in get_node(spawn_path).get_children():
		remove_player_lobby.emit(player.name)
		player.queue_free()		
		
func remove_player(id: int)	-> void:
	remove_player_lobby.emit(id)
	get_node(spawn_path).get_node(str(id)).queue_free()
	
func lobby_player_connection(id: int) -> void:
	var pInfo: Dictionary = HighLevelNetworkHandler.connected_players[id]
	var player: PlayerLobby = player_lobby.instantiate()
	player.name = str(id)
	
	get_node(spawn_path).call_deferred("add_child", player)
	player.setDetails(pInfo["icon"],pInfo["name"], false)

	add_player_lobby.emit(id, player)
