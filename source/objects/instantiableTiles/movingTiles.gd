extends KinematicBody2D
#takes the moving speed from a global node
#that is a singleton set in the project
#settings
var movingSpeed = globals.movingObjectsSpeed

func _on_visibilityNotifier_exit_screen():
	#clear this node from memory when it
	#is out the screen (meaning we don't
	#need it anymore) 
	queue_free()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	#moves this node towards the end of screen
	#to give the illusion that the player is
	#moving (or not we will see)
	move(Vector2(-1, 0) * movingSpeed * delta)
	if is_colliding():
		#also checks if the player collided from a horizontal
		#collision, if it does, game over.
		#This only checks for horizontal collisions because
		#the player can jump on this obstacles
		#and can also hit the head on obstacles bottom
		if get_collision_normal().x != 0 and get_collider() != null and get_collider().is_in_group("player"):
			get_tree().quit()

func _on_item_body_enter( body ):
	if body.is_in_group("player"):
		globals.score += 100
		print("scored")
	if body != self:
		get_node("corn").queue_free()
