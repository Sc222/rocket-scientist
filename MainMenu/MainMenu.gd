extends Control

const BG_SPEED = -50
const FIRST_STAGE_LINK = "res://FirstStageLoad/FirstStageLoad.tscn"


func _ready():
	OS.min_window_size = Vector2(975, 550)
	get_tree().paused = false
	$Rocket.play("flight")


func _process(delta):
	$ParallaxBackground.scroll_offset.x+=BG_SPEED*delta


func launch_game():
	get_tree().change_scene(FIRST_STAGE_LINK)


func launch_credits():
	# todo launch credits
	pass


func exit():
	get_tree().quit()

