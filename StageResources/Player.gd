extends KinematicBody2D

export var speed = 16*20
#const DIR_LEFT = "l"
#const DIR_RIGHT="r"
#var direction=DIR_RIGHT
onready var sprite = get_node("Sprite")

func _ready():
	pass

func _physics_process(delta):
	var dir_vector: Vector2
	dir_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	dir_vector.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	
	if abs(dir_vector.x) == 1 and abs(dir_vector.y) == 1:
		dir_vector = dir_vector.normalized()
		
	var movement = speed * dir_vector * delta
	
	update_animation(dir_vector.x, movement.length()!=0)	
	
	move_and_collide(movement)

func update_animation(x_direction, is_moving):
	print(x_direction)
	print(x_direction<0)
	if x_direction>0:
		sprite.set_flip_h(false)
	elif x_direction<0:
		sprite.set_flip_h(true)
	if is_moving:
		sprite.play("run")
	else:
		sprite.play("idle")
