extends KinematicBody2D

export var speed = 16*20
const DIR_LEFT = "l"
const DIR_RIGHT="r"
var direction=DIR_RIGHT
onready var sprite = get_node("Sprite")
onready var pistol = get_node("Pistol")
onready var pistolSprite = pistol.get_node("Sprite")

func _ready():
	pass

func _physics_process(delta):
	var dir_vector: Vector2
	dir_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	dir_vector.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	
	if abs(dir_vector.x) == 1 and abs(dir_vector.y) == 1:
		dir_vector = dir_vector.normalized()
		
	var movement = speed * dir_vector * delta
	
	var is_direction_changed = change_direction(dir_vector.x)
	
	update_animation(movement.length()!=0)	
	move_and_collide(movement)
	rotate_pistol(get_global_mouse_position(), is_direction_changed)
	
#returns true if direction was changed
func change_direction(x_direction):
	var new_direction = direction
	if x_direction>0:
		new_direction = DIR_RIGHT
	if x_direction<0:
		new_direction = DIR_LEFT
	
	if new_direction != direction:
		direction=new_direction
		return true
	return false

func update_animation(is_moving):
	if direction==DIR_RIGHT:
		sprite.set_flip_h(false)
	elif direction==DIR_LEFT:
		sprite.set_flip_h(true)
	if is_moving:
		sprite.play("run")
	else:
		sprite.play("idle")

func rotate_pistol(mouse_pos, is_direction_changed):
	var angle = (mouse_pos - pistol.global_position).angle()
	var can_rotate_that_much = false
	if is_direction_changed:
		# we should mirror gun, so add PI to rot angle
		pistol.rotation += PI
		if direction==DIR_RIGHT:
			pistolSprite.set_flip_v(false)
		if direction==DIR_LEFT:
			pistolSprite.set_flip_v(true)
	#print(angle)

	if angle>-PI/2 and angle<PI/2:
		if direction==DIR_RIGHT:
			can_rotate_that_much=true
	else:
		if direction==DIR_LEFT:
			can_rotate_that_much=true
			
	if can_rotate_that_much:
		pistol.look_at(mouse_pos)
