extends PopupDialog


const MAIN_MENU_LINK = "res://MainMenu/MainMenu.tscn"
const RESTART_LINK = "res://StageResources/StageResources.tscn"
# last stage should not be added here
var stages = [
	"сбор ресурсов",
	"проектирование",
	"найм пилота"
]


# todo replace index with enum
func show_dialog(index, solved_tasks, tasks_total, tries):
	var tasks_percentage = stepify((solved_tasks*1.0)/tasks_total*100,0.1)
	var accuracy_percentage = stepify((solved_tasks*1.0)/tries*100,0.1)
	$Bg/StageInfo.set_text(stages[index])
	$Bg/TasksInfo.set_text(str(tasks_percentage) +"% ("+str(solved_tasks)+"/"+str(tasks_total)+")")
	$Bg/AccuracyInfo.set_text(str(accuracy_percentage) +"% ("+str(solved_tasks)+"/"+str(tries)+")")
	$AnimationPlayer.play("overlay_color")
	Global.game_over()  # set global score values to zero
	show()


func _on_MainMenu_pressed():
	get_tree().change_scene(MAIN_MENU_LINK)


func _on_Restart_pressed():
	get_tree().change_scene(RESTART_LINK)

