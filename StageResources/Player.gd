extends KinematicBody2D

const Bullet = preload("res://StageResources/Bullet.tscn")
export var speed = 16*20
const DIR_LEFT = "l"
const DIR_RIGHT="r"
const START_HP = 3
const COINS_TO_COLLECT = 3
const RELOAD_TIME = 0.4 #sec
var reload = 0.0
var direction=DIR_RIGHT
onready var sprite = get_node("Sprite")
onready var pistol = get_node("Pistol")
onready var pistolSprite = pistol.get_node("Animation")
onready var bulletSpawner = pistol.get_node("BulletSpawner")
onready var reloadIndicator = pistol.get_node("ReloadIndicator")
var hp = START_HP
var coins = 0


func _ready():
	pass


func _physics_process(delta):
	reload(delta)
	if Input.is_action_just_pressed("player_shoot") and reload == 0.0:
		reload = RELOAD_TIME
		shoot()
	
	var dir_vector: Vector2
	dir_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	dir_vector.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	
	if abs(dir_vector.x) == 1 and abs(dir_vector.y) == 1:
		dir_vector = dir_vector.normalized()
		
	var movement = speed * dir_vector * delta
	
	direction = rotate_pistol(get_global_mouse_position())
	update_animation(movement.length()!=0)	
	move_and_collide(movement)

func reload(delta):
	if reload > 0.0:
		$Pistol/ReloadIndicator.visible=true
		reload -= delta
	if reload <= 0:
		$Pistol/ReloadIndicator.visible=false
		reload = 0

func shoot():
	$Pistol/Animation.play("shoot")
	$Pistol/Animation.frame=0
	var bullet = Bullet.instance()
	#bullet is added as child of map to make it y-sortable
	bullet.global_position.x=$Pistol/BulletSpawner.global_position.x/5
	bullet.global_position.y=$Pistol/BulletSpawner.global_position.y/5
	bullet.global_rotation=$Pistol/BulletSpawner.global_rotation
	#PLAYER MUST BE CHILD OF "MAP" NODE
	get_parent().add_child(bullet)

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
	var dir = direction
	if angle>-PI/2 and angle<PI/2:
		pistolSprite.set_flip_v(false)
		bulletSpawner.position.y=-2.5
		reloadIndicator.position.y=-9
		dir = DIR_RIGHT
	else:
		pistolSprite.set_flip_v(true)
		bulletSpawner.position.y=2.5
		reloadIndicator.position.y=9
		dir=DIR_LEFT
	pistol.look_at(mouse_pos)
	return dir
