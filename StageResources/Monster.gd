extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null
export var speed = 3.5
const ATTACK_DISTANCE = 25
const DIR_LEFT = "l"
const DIR_RIGHT="r"
const START_HP = 3
const COINS_TO_COLLECT = 3
const RELOAD_TIME = 0.4 #sec
var reload = 0.0
var direction=DIR_RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	reload(delta)
	var movement = Vector2.ZERO
	if player:
		if position.distance_to(player.position)>ATTACK_DISTANCE:
			movement = position.direction_to(player.position) * speed
		else:
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
	player_pos.x += player.HALF_WIDTH
	player_pos.y -= player.HALF_HEIGHT
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

func _on_PlayerDetectArea_body_entered(body):
	if body.is_in_group("player"):
		player = body


func _on_PlayerDetectArea_body_exited(body):
	if body.is_in_group("player"):
		player = null

