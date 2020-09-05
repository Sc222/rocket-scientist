extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 200
const GROUPS_CAN_FLY_THROUGH =["background","monster","player","small_object"]
var is_despawning = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	#pass
	if not is_despawning:
		position += transform.x * speed * delta

func despawn():
	is_despawning=true
	$Sprite.play("detonate")
	print("BULLET DIE")

func _on_Sprite_animation_finished():
	if $Sprite.animation == "detonate":
		queue_free()

func _on_Bullet_body_entered(body):
	if body_is_in_one_of_groups(body,GROUPS_CAN_FLY_THROUGH):
		print("bullet should not collide with it")
	else:
		despawn()


func body_is_in_one_of_groups(body, groups):
	for group in groups:
		if body.is_in_group(group):
			return true
	return false

func _on_Bullet_screen_exited():
	queue_free()

