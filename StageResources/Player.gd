extends KinematicBody2D

export var speed = 16*20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	# Get player input
	var direction: Vector2
	direction.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	direction.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Apply movement
	var movement = speed * direction * delta
	move_and_collide(movement)
