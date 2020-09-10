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
	StageInfo.new("проектирование ракеты","res://StagePilots/StagePilots.tscn"),
	StageInfo.new("найм пилота","res://StageFlight/StageFlight.tscn")
]

var stage_index = -1


func show_dialog(index, solved_tasks,tasks_total):
	stage_index = index
	var stage_info = stages[index]
	var tasks_percentage = stepify((solved_tasks*1.0)/tasks_total*100,0.1)
	$Bg/StageInfo.set_text(stage_info.name)
	$Bg/TasksInfo.set_text(str(tasks_percentage) +"% ("+str(solved_tasks)+"/"+str(tasks_total)+")")
	$AnimationPlayer.play("overlay_color")
	show()


func _on_NextStage_pressed():
	print("NEXT STAGE NEXT STAGE")
	if stage_index != -1:
		get_tree().change_scene(stages[stage_index].next_stage_link)
