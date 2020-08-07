extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	#pass
	position += transform.x * speed * delta


func _on_Bullet_body_entered(body):
	pass
	#if body.is_in_group("mobs"):
	#    body.queue_free()
	queue_free()
