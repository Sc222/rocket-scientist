extends Node2D


# this stage is implemented because when stage resources is reloaded from itself 
# navigation polygon is not resetted
func _ready():
	get_tree().change_scene("res://StageResources/StageResources.tscn")

