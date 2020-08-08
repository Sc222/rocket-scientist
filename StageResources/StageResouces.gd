extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Ui/StatsBg/Ammo.text=str($Map/Player.bullets)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#update bullets amount
func _on_Player_change_bullets_count(bullets):
	$Ui/StatsBg/Ammo.text=str(bullets)
