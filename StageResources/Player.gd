extends KinematicBody2D

const Bullet = preload("res://StageResources/Bullet.tscn")
export var speed = 16*20
const DIR_LEFT = "l"
const DIR_RIGHT="r"
var direction=DIR_RIGHT
onready var sprite = get_node("Sprite")
onready var pistol = get_node("Pistol")
onready var pistolSprite = pistol.get_node("Animation")
onready var bulletSpawner = pistol.get_node("BulletSpawner")

func _ready():
	pass

func _physics_process(delta):
	#difference between pressed without just?
	if Input.is_action_just_pressed("player_shoot"):
		shoot()
	
	var dir_vector: Vector2
	dir_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	dir_vector.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	
	if abs(dir_vector.x) == 1 and abs(dir_vector.y) == 1:
		dir_vector = dir_vector.normalized()
		
	var movement = speed * dir_vector * delta
	
	#var is_direction_changed = change_direction(dir_vector.x)
	
	

	direction = rotate_pistol(get_global_mouse_position())
	update_animation(movement.length()!=0)	
	move_and_collide(movement)
	#change_direction(dir_vector.x)


func shoot():
	$Pistol/Animation.play("shoot")
	$Pistol/Animation.frame=0
	#todo delay?
	
	var bullet = Bullet.instance()
	#add bullet as child of map to make it y-sortable
	print("Spawner",$Pistol/BulletSpawner.global_position)
	bullet.global_position.x=$Pistol/BulletSpawner.global_position.x/5
	bullet.global_position.y=$Pistol/BulletSpawner.global_position.y/5
	bullet.global_rotation=$Pistol/BulletSpawner.global_rotation
	owner.get_node("Map").add_child(bullet)

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

func rotate_pistol(mouse_pos):
	var angle = (mouse_pos - pistol.global_position).angle()
	var can_rotate_that_much = false
	var dir = direction
	if angle>-PI/2 and angle<PI/2:
		pistolSprite.set_flip_v(false)
		bulletSpawner.position.y=-2.5
		dir = DIR_RIGHT
	else:
		pistolSprite.set_flip_v(true)
		bulletSpawner.position.y=2.5
		dir=DIR_LEFT
	pistol.look_at(mouse_pos)
	return dir
