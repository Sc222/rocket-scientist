extends Node2D

var BG_SPEED = -50
var FLIGHT_LENGTH = 45 # sec (60 secs) 
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
#todo MORE TASKS
var planet_tasks = [
	PlanetTaskInfo.new("Фабрика выпускает сумки. В среднем 8 сумок из 100 имеют скрытые дефекты. Найдите вероятность того, что купленная сумка окажется без дефектов.","0,93",["1,08","0,93","0,8"]),
	PlanetTaskInfo.new("При производстве в среднем на каждые 2982 исправных насоса приходится 18 неисправных. Найдите вероятность того, что случайно выбранный насос окажется неисправным.","0,006",["0,006","0,018","0,42"]),
	PlanetTaskInfo.new("Какова вероятность того, что случайно выбранный телефонный номер оканчивается двумя чётными цифрами?","0,25",["0,2","0,25","0,01"]),
	PlanetTaskInfo.new("Вероятность того, что новый электрический чайник прослужит больше года, равна 0,93. Вероятность того, что он прослужит больше двух лет, равна 0,87. Найдите вероятность того, что он прослужит меньше двух лет, но больше года.","0,06",["0,06","0,18","0,36"]),
	PlanetTaskInfo.new("Из районного центра в деревню ежедневно ходит автобус. Вероятность того, что в понедельник в автобусе окажется меньше 18 пассажиров, равна 0,82. Вероятность того, что окажется меньше 10 пассажиров, равна 0,51. Найдите вероятность того, что число пассажиров будет от 10 до 17.","0,31",["0,31","0,48","0,1"]),
	PlanetTaskInfo.new("Фабрика выпускает сумки. В среднем на 190 качественных сумок приходится восемь сумок со скрытыми дефектами. Найдите вероятность того, что купленная сумка окажется качественной. Результат округлите до сотых.","0,96",["0,96","0,75","0,24"]),
	PlanetTaskInfo.new("Вероятность того, что в случайный момент времени температура тела здорового человека окажется ниже чем 36,8 °С, равна 0,81. Найдите вероятность того, что в случайный момент времени у здорового человека температура окажется 36,8 °С или выше.","0,19",["0,2","0,1","0,19"])
]
var current_task = null
var is_stage_completed = false


func _ready():
	get_tree().paused = false
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
	planet.connect("planet_dispawned",self,"on_planet_dispawn")
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
				$UI/TaskContainer/Task.set_text(NO_PLANETS)
				if $PlanetContainer.get_child_count()>0:
					$PlanetContainer.get_child(0).despawn()
				
			else:
				$UI/TaskContainer/Task.set_text(PLANET_APPROACHES)
				if $PlanetContainer.get_child_count()>0:
					$PlanetContainer.get_child(0).speed_up()
			current_task = null
			$UI/Variants.visible = false
			break

func on_planet_dispawn():
	print("SPAWN NEW")
	$PlanetSpawnTimer.start()

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
	$PlanetSpawnTimer.stop()
	
	# dont spawn new planet if there is still one on the map
	if $PlanetContainer.get_child_count()>0:
		$PlanetSpawnTimer.start()
		return
	
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
