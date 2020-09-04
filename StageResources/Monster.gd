extends KinematicBody2D


const HALF_WIDTH=6
const HALF_COLLISION_HEIGHT=2
const ATTACK_DISTANCE = 25
const DIR_LEFT = "l"
const DIR_RIGHT="r"
const START_HP = 3
const COINS_TO_COLLECT = 3
const RELOAD_TIME = 0.4 #sec
var is_visible = false
var player = null
var navigation = null
export var speed = 3.5
var reload = 0.0
var direction=DIR_RIGHT

# call init after instancing monster scene
func init(player, navigation):
	self.player = player
	self.navigation = navigation


func _physics_process(delta):
	reload(delta)
	var movement = Vector2.ZERO
	if is_visible:
		#todo helper method for shifting position
		var tmp_pos = position
		tmp_pos.x += HALF_WIDTH
		tmp_pos.y -= HALF_COLLISION_HEIGHT
		var tmp_player_pos = player.position
		tmp_player_pos.x += player.HALF_WIDTH
		tmp_player_pos.y -= player.HALF_COLLISION_HEIGHT
		
		var path_to_player = navigation.get_simple_path(tmp_pos, tmp_player_pos)
		
		#debug line
		get_parent().get_parent().get_parent().get_node("debugLine").points=path_to_player
		
		movement = (path_to_player[1] - tmp_pos).normalized()*speed

		# attack_if_close
		if path_to_player.size()==2 and (path_to_player[1] - tmp_pos).length()<ATTACK_DISTANCE:
			movement = Vector2.ZERO
			if reload == 0.0:
				attack()
		direction = rotate_knife(player.global_position)
	update_animation(movement.length()!=0)
	move_and_collide(movement) 


func reload(delta):
	if reload > 0.0:
		reload -= delta
	if reload <= 0:
		reload = 0


func attack():
	reload = RELOAD_TIME
	$AnimationPlayer.play("attack_"+direction)


func rotate_knife(player_pos):
	player_pos.x += player.HALF_WIDTH*5
	player_pos.y -= player.HALF_HEIGHT*5
	var angle = (player_pos - $Dagger.global_position).angle()
	var dir = direction
	if angle>-PI/2 and angle<PI/2:
		$Dagger/Sprite.set_flip_v(false)
		dir = DIR_RIGHT
	else:
		$Dagger/Sprite.set_flip_v(true)
		dir=DIR_LEFT
	$Dagger.look_at(player_pos)
	return dir


func update_animation(is_moving):
	if direction==DIR_RIGHT:
		$Sprite.set_flip_h(false)
	elif direction==DIR_LEFT:
		$Sprite.set_flip_h(true)
	if is_moving:
		$Sprite.play("run")
	else:
		$Sprite.play("idle")


func _on_screen_entered():
	is_visible = true


func _on_screen_exited():
	is_visible = false
