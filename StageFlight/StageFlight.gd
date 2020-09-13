extends Control

const BG_SPEED = -50


func _ready():
	get_tree().paused = false
	Global.current_stage = Global.STAGE.FLIGHT


func _process(delta):
	$ParallaxBackground.scroll_offset.x+=BG_SPEED*delta

