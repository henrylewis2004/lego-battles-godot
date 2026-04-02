class_name NetworkHandler
extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 42069

const MAX_CLIENT_COUNT: int = 6

var peer: ENetMultiplayerPeer

func start_sever():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENT_COUNT)
	multiplayer.multiplayer_peer = peer


func start_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer

@rpc("authority", "call_local", "reliable")
func start_game() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels/battle/testbattlelev.tscn")
