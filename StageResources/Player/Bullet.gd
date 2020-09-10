extends Area2D

const GROUPS_CAN_FLY_THROUGH =["background","monster","player","small_object"]
var speed = 200
var is_despawning = false


func _physics_process(delta):
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

