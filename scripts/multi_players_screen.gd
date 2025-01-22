extends Node2D

@onready var transition = $transition

@export var address: String = global.online_ip_address
@export var port: int = global.online_port
@export var max_client = global.online_max_client

var peer: ENetMultiplayerPeer

@export var online_players = {}

var online_on = true

@rpc
func update_player(players: Dictionary):
	if not global.is_host:
		online_players = players.duplicate(true)

# only host should be able to execute this function
@rpc("any_peer", 'call_local')
func add_player(peer_id, skin_index: int, player_name: String, is_p_ready: bool):
	if online_players.has(peer_id):
		online_players[peer_id]["skin_index"] = skin_index
		online_players[peer_id]["name"] = player_name
		online_players[peer_id]["is_ready"] = is_p_ready
	else:
		var player_id = get_last_position()
		online_players[peer_id] = {
			"peer_id": peer_id,
			"player_id": player_id,
			"skin_index": global.player_skin[player_id-1], 
			"name": player_name, 
			"is_ready": is_p_ready
		}

	update_player.rpc(online_players)

@rpc("any_peer", 'call_local')
func remove_player(peer_id):
	if online_players.has(peer_id):
		var player_id = online_players[peer_id]["player_id"]
		
		for cp_id in online_players:
			var cp = online_players[cp_id]
			if cp["player_id"] >= player_id:
				cp["player_id"] -= 1
				
		online_players.erase(peer_id)
		update_player.rpc(online_players)

func get_peer_id(player_id):
	for peer_id in online_players:
		if online_players[peer_id]["player_id"] == player_id:
			return peer_id

func get_player_id(peer_id):
	return online_players[peer_id]["player_id"]

func get_last_position():
	return online_players.size() + 1

func is_skin_taken(color : int, peer_id : int):
	for player in online_players:
		if online_players[player]["skin_index"] == color and player != peer_id and online_players[player]["is_ready"]:
			return true
	return false

func is_ready():
	pass #heeeere

func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if global.is_host:
		host_game()
	else:
		join_game()

# called on server and clients
func peer_connected(id):
	print("Player connected : " + str(id))

# called on server and clientsd
func peer_disconnected(id):
	print("Player disconnected : " + str(id))
	if id == 1 and not global.is_host:
		online_on = false
		multiplayer.multiplayer_peer = null
		transition.exit("exit")
	if global.is_host and online_players.has(id):
		remove_player(id)

# called only from client
func connected_to_server():
	print("connected to server")
	add_player.rpc_id(1, multiplayer.get_unique_id(), -1, global.online_name, false)

# called only from client
func connection_failed():
	print("connection failed")

func host_game():
	online_players.clear()
	
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, max_client)
	if error != OK:
		print("cannot host ahah bozo: " + error)
		return
	
	#didn't understand what compression is for but it's optional I think
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	add_player(multiplayer.get_unique_id(), global.player_skin[0], global.online_name, false)
	#$player1_host.activate(true)
	
	print("Waiting for player...")
	

func join_game():
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	
	# need to be the same than server
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	#frames[player_index].activate(true)

func leave_game(peer_id):
	#if global.is_host:
		#online_on = false
		#for c_peer_id in online_players:
			#if c_peer_id != peer_id:
				#leave_game(c_peer_id)
	online_on = false
	remove_player.rpc_id(1, peer_id)
	multiplayer.multiplayer_peer = null
	transition.exit("exit")

func close_host():
	if global.is_host:
		peer.free()


func _on_transition_exited(msg: Variant) -> void:
	match msg:
		"exit": get_tree().change_scene_to_file("res://scenes/multi_screen.tscn")
