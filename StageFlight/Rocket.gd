extends Area2D

signal win
signal die
signal change_hp

var hp = 0
var is_exploding = false
var is_win = false
const despawn_speed = 2
const win_speed = 5

func _ready():
	#todo remove later
	Global.final_stage_hp = 2
	hp = Global.final_stage_hp


func _physics_process(delta):
	if is_exploding:
		position += transform.y * despawn_speed 
		position -= transform.x * despawn_speed 
	elif is_win:
		position += transform.x * win_speed 


func win():
	if not is_exploding:
		is_win = true
		$HitPolygon.set_disabled(true)
		emit_signal("win")


func hit():
	hp-=1
	emit_signal("change_hp")
	if hp == 0:
		is_exploding = true
		$Sprite.play("die")
	else:
		pass
		$Sprite.play("hit")


func _on_Rocket_area_entered(area):
	if area.is_in_group("deadly"):
		hit()


func _on_Sprite_animation_finished():
	if $Sprite.animation =="hit":
		$Sprite.play("fly")
	if $Sprite.animation =="die":
		emit_signal("die")
		queue_free()

