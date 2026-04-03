class_name NetworkHandler
extends Node

signal updateLobby

const IP_ADDRESS: String = "localhost"
const PORT: int = 42069

const MAX_CLIENT_COUNT: int = 6

var peer: ENetMultiplayerPeer
var connected_players: Dictionary[int, PlayerInformation]

@rpc("authority", "reliable")
func receive_player(id: int, playerInfo: PlayerInformation) -> void:
	connected_players[id] = playerInfo
	
@rpc("authority", "reliable")
func remove_player(id: int) -> void:
	connected_players.erase(id)

@rpc("any_peer", "reliable")
func register_player(playerInfo: PlayerInformation):
	if !multiplayer.is_server(): return

	var sender_id : int = multiplayer.get_remote_sender_id()
	
	receive_player.rpc(sender_id,playerInfo)
	receive_player(sender_id,playerInfo)

@rpc("authority", "reliable")
func request_lobby_update():
	updateLobby.emit()
	

## host functions
func start_sever() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENT_COUNT)
	multiplayer.multiplayer_peer = peer
	
func register_host() -> void:
	if !multiplayer.is_server(): return
	
	register_player(PlayerInfo)

## client functions
func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer


## signals
func on_connected_to_server(peer_id: int) -> void:
	register_player.rpc_id(1,PlayerInfo)

func peer_disconnect_from_server(peer_id: int) -> void:
	if !multiplayer.is_server(): return
		
	remove_player(peer_id)
	remove_player.rpc(peer_id)
	
	request_lobby_update.rpc()
	
func peer_connect_to_server(peer_id: int) -> void:
	if !multiplayer.is_server(): return
	
	for id in connected_players:
		receive_player.rpc_id(peer_id, id, connected_players[id])
		
	request_lobby_update.rpc()
	






@rpc("authority", "call_local", "reliable")
func start_game() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels/battle/testbattlelev.tscn")

func connect_signals() -> void:
	multiplayer.peer_connected.connect(peer_connect_to_server)
	multiplayer.peer_disconnected.connect(peer_disconnect_from_server)
	multiplayer.connected_to_server.connect(on_connected_to_server)
#	multiplayer.connection_failed.connect(_on_connection_failed)
#	multiplayer.server_disconnected.connect(_on_server_disconnected)


func _ready() -> void:
	connect_signals()
