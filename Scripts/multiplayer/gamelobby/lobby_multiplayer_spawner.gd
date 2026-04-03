class_name LobbyMultiplayerSpawner extends MultiplayerSpawner

@export var player_lobby: PackedScene

func get_PlayerLobbyDict() -> Dictionary[int,PlayerLobby]:
	var players := get_node(spawn_path).get_children()
	var res : Dictionary[int, PlayerLobby]
	for player in players:
		res[int(player.name)] = player
	return res
	

func clear() -> void:
	if !multiplayer.is_server(): return
	
	for player in get_node(spawn_path).get_children():
		player.queue_free()		
		
func remove_player(id: int)	-> void:
	if !multiplayer.is_server(): return
	
	get_node(spawn_path).get_node(str(id)).queue_free()
	
func lobby_player_connection(id: int) -> void:
	if !multiplayer.is_server(): return

	var pInfo: Dictionary = HighLevelNetworkHandler.connected_players[id]
	var player: PlayerLobby = player_lobby.instantiate()
	player.name = str(id)
		
	player.setDetails(pInfo["icon"],pInfo["name"], false)
	
	get_node(spawn_path).call_deferred("add_child", player)
