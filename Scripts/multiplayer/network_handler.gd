class_name LocalNetworkHandler
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
