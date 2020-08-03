extends Control

const BG_SPEED = -50
onready var ParallaxBg = get_node("ParallaxBackground")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(delta)
	ParallaxBg.scroll_offset.x+=BG_SPEED*delta
	pass
