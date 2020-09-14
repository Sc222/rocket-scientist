extends Node2D

var BG_SPEED = -50
var FLIGHT_LENGTH = 10 # sec (60 secs) 
var remaining_time = FLIGHT_LENGTH
const NO_PLANETS = "Нет планет в зоне видимости."
const PLANET_APPROACHES = "Тревога.\nПланета надвигается."
const WIN = "Победа.\nПутешествие завершено."
const LOSE = "Поражение.\nНе удалось завершить полёт."

class PlanetTaskInfo:
	
	var task = ""
	var answer = ""
	var answer_variants = []
	
	func _init(task_val, answer_val, answer_variants_val):
		self.task = task_val
		self.answer = answer_val
		self.answer_variants = answer_variants_val



const Planet = preload("res://StageFlight/Planet.tscn")
# !!! warning: max flight length = planet_tasks.size() * PlanetSpawnTimer.waittime()
var planet_tasks = [
	PlanetTaskInfo.new("Задача с ответом 1","1",["1","2","3"]),
	PlanetTaskInfo.new("Задача с ответом 4","4",["6","5","4"]),
	PlanetTaskInfo.new("Задача с ответом 7","7",["7","8","9"]),
	PlanetTaskInfo.new("Задача с ответом 10","10",["11","10","12"]),
	PlanetTaskInfo.new("Задача с ответом 13","13",["13","14","15"]),
	PlanetTaskInfo.new("Задача с ответом 0.5","0.5",["0.5","0.75","0.25"])
]
var current_task = null
var is_stage_completed = false


func _ready():
	get_tree().paused = false
	Global.current_stage = Global.STAGE.FLIGHT
	$UI/Hp.set_text(str($Rocket.hp))
	$UI/RemainingTime.set_text(str(remaining_time))
	$UI/TaskContainer.visible = false
	$UI/Variants.visible = false
	spawn_planet()


func _process(delta):
	$ParallaxBackground.scroll_offset.x+=BG_SPEED*delta
	if current_task != null:
		check_answer()

func spawn_planet():
	Global.tasks_total+=1
	
	# set task info
	var task_index = randi()%planet_tasks.size()
	current_task = planet_tasks[task_index]
	planet_tasks.remove(task_index)
	$UI/TaskContainer/Task.set_text(current_task.task)
	
	for i in range(0, current_task.answer_variants.size()):
		get_node("UI/Variants/Variant"+str(i+1)).set_text(current_task.answer_variants[i])
	
	$UI/TaskContainer.visible = true
	$UI/Variants.visible = true
	
	
	# setup planet
	var planet = Planet.instance()
	randomize()
	var positions_size = $PlanetsPositions.get_children().size()
	var spawner_index = randi() % positions_size
	var spawner = $PlanetsPositions.get_children()[spawner_index]
	$PlanetContainer.add_child(planet)
	planet.global_position.x=spawner.global_position.x
	planet.global_position.y=spawner.global_position.y
	
func check_answer():
	for i in range(0, current_task.answer_variants.size()):
		var is_answer_selected = Input.is_action_just_pressed("select_answer_"+str(i+1))
		if is_answer_selected:
			Global.tries+=1
			var answer = str(current_task.answer_variants[i])
			print("selected: ",answer, "correct: ", current_task.answer)
			var is_correct_answer = answer == current_task.answer
			print(is_correct_answer)
			if is_correct_answer:
				Global.solved_tasks+=1
				print($PlanetContainer.get_child_count())
				var planet = $PlanetContainer.get_child(0)
				$UI/TaskContainer/Task.set_text(NO_PLANETS)
				if planet:
					planet.despawn()
			else:
				$UI/TaskContainer/Task.set_text(PLANET_APPROACHES)
			current_task = null
			$UI/Variants.visible = false
			break

func _on_SecondTickTimer_timeout():
	remaining_time-=1
	$UI/RemainingTime.set_text(str(remaining_time))
	if remaining_time == 0:
		$Rocket.win()
		$UI/TaskContainer/Task.set_text(NO_PLANETS)
		
		# remove planet if exists
		if $PlanetContainer.get_child_count()>0:
			$PlanetContainer.get_child(0).despawn()
		$SecondTickTimer.stop()
		$PlanetSpawnTimer.stop()


func _on_PlanetSpawnTimer_timeout():
	if remaining_time >= 0:
		spawn_planet()


func _on_Rocket_change_hp():
	$UI/TaskContainer/Task.set_text(NO_PLANETS)
	$UI/Variants.visible = false
	$UI/Hp.set_text(str($Rocket.hp))


func _on_Rocket_die():
	$SecondTickTimer.stop()
	$PlanetSpawnTimer.stop()
	complete_stage(false)


func _on_Rocket_win():
	complete_stage(true)


func complete_stage(is_success):
	if is_stage_completed:
		return
	is_stage_completed = true
	get_tree().paused=true
	if is_success:
		$UI/TaskContainer/Task.set_text(WIN)
		$UI/WinDialog.show_dialog(Global.solved_tasks, Global.tasks_total, Global.tries)
	else:
		$UI/TaskContainer/Task.set_text(LOSE)
		$UI/GameOverDialog.show_dialog(3, Global.solved_tasks, Global.tasks_total, Global.tries)
