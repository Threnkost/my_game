extends Node

enum {
	ONLINE,
	OFFLINE
}

const PORT = 3444
const HOST = "localhost"

var network   = NetworkedMultiplayerENet.new()
var user_name : String

var _network_id
var network_state = OFFLINE


func _ready():
	get_tree().connect("connected_to_server", self, "_on_ConnectedToServer")
	
	ConnectToServer(HOST, PORT)
	
	user_name = ProjectSettings.get("global/user_name")


func ConnectToServer(host, port):
	network.create_client(HOST, PORT)
	get_tree().network_peer = network
	
	yield(get_tree(), "connected_to_server")

	_network_id = get_tree().get_network_unique_id()
	
	rpc_id(1, "RegisterPlayer", get_tree().get_network_unique_id(), user_name.sha256_text(), user_name)


func _on_ConnectedToServer():
	network_state = ONLINE
	

func is_online() -> bool:
	return network_state == ONLINE


func SendPlayerData(player_data):
	if network_state == ONLINE:
		rpc_unreliable_id(1, "ReceivePlayerData", player_data)


func SendPlayerInventoryData(inv_data : Dictionary):
	if network_state == ONLINE:
		rpc_id(1, "ReceivePlayerInventoryData", inv_data)


func FetchPlayerName(player_id, requester):
	if network_state == ONLINE:
		rpc_id(1, "FetchPlayerName", player_id, requester)


func entity_hit(entity_uid, damage):
	if network_state == ONLINE:
		rpc_id(1, "entity_hit", entity_uid, damage)
		
	
func drop_item(item_id, amount, pos):
	rpc_id(1, "drop_item", item_id, amount, pos)
		
		
func _on_Drop_collected(dropped_item_id):
	rpc_id(1, "drop_collected", dropped_item_id)


remote func receive_world_map_data(world_name, map_tile_data, tree_map):
	get_node("/root/World").load_world_map(map_tile_data, tree_map)


remote func receive_last_position(last_pos):
	get_node("/root/World").last_player_position = last_pos


remote func ReturnInventoryData():
	var inv = get_node("/root/World/UI/Inventory")
	var inv_data = inv.GetInventoryDataAsText()
	SendPlayerInventoryData(inv_data)
	print("Returning : ", inv_data)


remote func ReceiveInventoryData(inv_data): #WIP
	get_node("/root/World/UI/Inventory").LoadInventory(inv_data)


remote func ReturnPlayerName(player_id, requester, requested_name):
	
	var instance = instance_from_id(requester)
	if instance.has_method("SetPlayerName"):
		instance.SetPlayerName(requested_name)
	else:
		print("\n[?] Requester '%s' does not have target func to fetch 'Player Name'.\n" % [instance_from_id(requester).name])


remote func ReceiveWorldState(world_state):
	get_node("/root/World").UpdateWorldState(world_state)


remote func load_item(item_id:String, data:Dictionary):
	LoadManager.load_item_data(item_id, data)
