extends Control

const BG_SPEED = -50
onready var ParallaxBg = get_node("ParallaxBackground")


func _ready():
	OS.min_window_size = Vector2(975, 550)
	$Rocket.play("flight")


func _process(delta):
	ParallaxBg.scroll_offset.x+=BG_SPEED*delta


func launch_game():
	get_tree().change_scene("res://StageResources/StageResouces.tscn")


func launch_credits():
	# todo launch credits
	pass


func exit():
	get_tree().quit()

