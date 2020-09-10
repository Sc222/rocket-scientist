extends KinematicBody2D

signal win
signal die
signal change_hp

const Bullet = preload("res://StageResources/Bullet.tscn")
export var speed = 7
const HALF_WIDTH=6
const HALF_HEIGHT=9
const HALF_COLLISION_HEIGHT=2
const DIR_LEFT = "l"
const DIR_RIGHT="r"
const START_HP = 3
const COINS_TO_COLLECT = 3
const RELOAD_TIME = 0.3 #sec
var reload_val = 0.0
var direction=DIR_RIGHT
var hp = START_HP
var coins = 0
var is_vulnerable = true # player is invulnerable while hit animation is playing


func _ready():
	$Pistol/ReloadIndicator.play()


func _physics_process(delta):
	if hp <= 0:
		return
	
	reload(delta)
	if Input.is_action_just_pressed("player_shoot") and reload_val == 0.0:
		reload_val = RELOAD_TIME
		shoot()
	var movement = Vector2.ZERO
	movement.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	movement.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	movement = movement.normalized()*speed
	direction = rotate_pistol(get_global_mouse_position())
	update_animation(movement.length()!=0)
	move_and_collide(movement)

func reload(delta):
	if reload_val > 0.0:
		$Pistol/ReloadIndicator.visible=true
		reload_val -= delta
	if reload_val <= 0:
		$Pistol/ReloadIndicator.visible=false
		reload_val = 0

func shoot():
	$Pistol/Animation.play("shoot")
	$Pistol/Animation.frame=0
	var bullet = Bullet.instance()
	get_parent().add_child(bullet)
	#bullet is added as child of map to make it y-sortable
	bullet.global_position.x=$Pistol/BulletSpawner.global_position.x
	bullet.global_position.y=$Pistol/BulletSpawner.global_position.y
	bullet.global_rotation=$Pistol/BulletSpawner.global_rotation
	#PLAYER MUST BE CHILD OF "MAP" NODE
	


func update_animation(is_moving):
	if direction==DIR_RIGHT:
		$Sprite.set_flip_h(false)
		$HitArea/HitPolygon.position.x=0
	elif direction==DIR_LEFT:
		$Sprite.set_flip_h(true)
		$HitArea/HitPolygon.position.x=-1
	if is_moving:
		$Sprite.play("run")
	else:
		$Sprite.play("idle")

func rotate_pistol(mouse_pos):
	var angle = (mouse_pos - $Pistol.global_position).angle()
	var dir = direction
	if angle>-PI/2 and angle<PI/2:
		$Pistol/Animation.set_flip_v(false)
		$Pistol/BulletSpawner.position.y=-2.5
		$Pistol/ReloadIndicator.position.y=-9
		dir = DIR_RIGHT
	else:
		$Pistol/Animation.set_flip_v(true)
		$Pistol/BulletSpawner.position.y=2.5
		$Pistol/ReloadIndicator.position.y=9
		dir=DIR_LEFT
	$Pistol.look_at(mouse_pos)
	return dir
	
func collect_coin():
	coins+=1
	if coins == COINS_TO_COLLECT:
		emit_signal("win")

func hit():
	if is_vulnerable:
		is_vulnerable = false
		hp-=1
		emit_signal("change_hp")
		if hp == 0:
			print("player die")
			$Pistol.visible=false
			$Sprite.play("die")
		else:
			$AnimationPlayer.seek(0)
			$AnimationPlayer.play("hit")


func _on_Sprite_animation_finished():
	if $Sprite.animation == "die":
		emit_signal("die")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hit":
		is_vulnerable = true


func _on_HitArea_area_entered(area):
	if area.is_in_group("deadly"):
		print("hit")
		#todo better way to send signal FROM dagger
		#todo what about knockback
		hit()

