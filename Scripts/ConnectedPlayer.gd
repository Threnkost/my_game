extends KinematicBody2D


var nickname := "Unnamed"

var direction :int = 1 setget SetDirection


func Initiate(player_id : int) -> void:

	GameConnection.FetchPlayerName(player_id, get_instance_id())


func MoveTo(target_pos : Vector2):
	set_global_position(target_pos)


func SetDirection(new_dir):
	direction = new_dir
	
	if new_dir == 1:
		$PeerPlayer.flip_h = false
		
	else:
		$PeerPlayer.flip_h = true


func SetPlayerName(_nickname : String):
	nickname = _nickname
	$Name.text = nickname
