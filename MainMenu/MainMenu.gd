extends Control

const BG_SPEED = -50
onready var ParallaxBg = get_node("ParallaxBackground")


func _ready():
	pass # Replace with function body.

func _process(delta):
	ParallaxBg.scroll_offset.x+=BG_SPEED*delta
	pass

func launch_game():
	pass

func launch_leaderboards():
	# todo launch leaderboards
	pass

func launch_credits():
	# todo launch credits
	pass

func exit():
	get_tree().quit()
