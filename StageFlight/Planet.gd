extends Area2D

signal planet_dispawned

const SPRITES_COUNT = 9
#const speed = -0.05
var speed = -0.2
var SPEED_UP_FACTOR = 6
const despawn_y_speed = -3
var is_despawning = false
var is_exploding = false

func _ready():
	randomize()
	var planet_sprite = 1 + randi()%SPRITES_COUNT
	print(planet_sprite)
	$Sprite.play("planet_"+str(planet_sprite))


func _physics_process(delta):
	if is_exploding:
		return
	
	position += transform.x * speed 
	if is_despawning:
		position += transform.y * despawn_y_speed 

func speed_up():
	speed = speed * SPEED_UP_FACTOR

func despawn():
	is_despawning=true
	$DespawnTimer.start()


func _on_ExplosionSprite_animation_finished():
	emit_signal("planet_dispawned")
	queue_free()


func _on_Planet_area_entered(area):
	is_exploding = true
	$Sprite.visible = false
	$ExplosionSprite.frame = 0
	$ExplosionSprite.play()


func _on_DespawnTimer_timeout():
	emit_signal("planet_dispawned")
	queue_free()

