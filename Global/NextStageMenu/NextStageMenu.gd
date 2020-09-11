extends PopupDialog


class StageInfo:
	
	var name = ""
	var next_stage_link = ""
	
	func _init(name_val, next_stage_link_val):
		self.name = name_val
		self.next_stage_link = next_stage_link_val


# last stage should not be added here
var stages = [
	StageInfo.new("сбор ресурсов","res://StageDesign/StageDesign.tscn"),
	StageInfo.new("проектирование","res://StagePilots/StagePilots.tscn"),
	StageInfo.new("найм пилота","res://StageFlight/StageFlight.tscn")
]
var stage_index = -1


func show_dialog(index):
	stage_index = index
	var stage_info = stages[index]
	$Bg/StageInfo.set_text(stage_info.name)
	$AnimationPlayer.play("overlay_color")
	show()


func _on_NextStage_pressed():
	print("NEXT STAGE NEXT STAGE")
	if stage_index != -1:
		get_tree().change_scene(stages[stage_index].next_stage_link)

