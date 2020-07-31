extends Control

var FAILURE="Поражение"
var NO_PILOT_HP="Выберите другого\nпилота"
var NO_HP="Не осталось попыток"
var STAGE_FINISHED="Пилот успешно нанят"
var WIN="Победа"

onready var taskHeaderLabel = get_node("TaskInfo/Bg/TaskHeader")
onready var answerInput = get_node("TaskInfo/ApplyTask/AnswerLineEdit")
onready var taskLabel = get_node("TaskInfo/Bg/TaskContainer/Task")
onready var pilotPhoto = get_node("Pilot"+str(current_pilot+1))
onready var pilotName = get_node("Name")
onready var result = get_node("Result")
onready var pilotCoolness = get_node("Coolness")
onready var pilotHpLabel = get_node("Tries/PilotHpText")
onready var hpLabel = get_node("Tries/HpText")
onready var applyPilotButton = get_node("PilotInfo/ApplyPilot")
onready var pilotTaskDifficulty = get_node("PilotInfo/Bg/Difficulty")
onready var applyTask = get_node("TaskInfo/ApplyTask")
onready var pilotInfo = get_node("PilotInfo")
onready var taskInfo = get_node("TaskInfo")
var current_pilots = { }
var current_pilot = 0
var currentTaskText = ""
var is_Task_Solved = false
var pilot_hp = 2
var hp = 2
var user_answer = ""

#словарь имен и анимаций
var avatars_dict = {
	"Такенори Кайягаки" : "pilot_1",
	"Иван Андреев" : "pilot_2",
	"Изабелла Коллинз" : "pilot_3",
	"Виктория Иванова" : "pilot_4",
	"Батя Влада М" : "pilot_5",
	"Сьюзан Ли" : "pilot_6",
	"Анонимус" : "pilot_7",
	"Йозеф Кнехт" : "pilot_8",
	"Утано Сакайя" : "pilot_9",
	"Незнакомец в шляпе" : "pilot_10",
	"Сохо Акигава" : "pilot_11",
	"Стефани Гонзалес" : "pilot_12"
}

var coolness_arr = [
	"coolness_25",
	"coolness_50",
	"coolness_75",
	"coolness_100"
]

var difficulty_dict = {
	"coolness_25": "Простая",
	"coolness_50": "Средняя",
	"coolness_75": "Сложная",
	"coolness_100": "Очень сложная"
}

var tasks_dict_25 = {
	"Легкая задача. Ответ на задание равен 0.":"0",
	"Легкая задача. Ответ на задание равен 1.":"1",
	"Легкая задача. Ответ на задание равен 2.":"2",
	"Легкая задача. Ответ на задание равен 3.":"3",
	"Легкая задача. Ответ на задание равен 4.":"4"
}

var tasks_dict_50 = {
	"Средняя задача. Ответ на задание равен 0.":"0",
	"Средняя задача. Ответ на задание равен 1.":"1",
	"Средняя задача. Ответ на задание равен 2.":"2",
	"Средняя задача. Ответ на задание равен 3.":"3",
	"Средняя задача. Ответ на задание равен 4.":"4"
}

var tasks_dict_75 = {
	"Сложная задача. Ответ на задание равен 0.":"0",
	"Сложная задача. Ответ на задание равен 1.":"1",
	"Сложная задача. Ответ на задание равен 2.":"2",
	"Сложная задача. Ответ на задание равен 3.":"3",
	"Сложная задача. Ответ на задание равен 4.":"4"
}

var tasks_dict_100 = {
	"Очень сложная задача. Ответ на задание равен 0.":"0",
	"Очень сложная задача. Ответ на задание равен 1.":"1",
	"Очень сложная задача. Ответ на задание равен 2.":"2",
	"Очень сложная задача. Ответ на задание равен 3.":"3",
	"Очень сложная задача. Ответ на задание равен 4.":"4"
}


func _ready():
	change_ui_visibility(false, false)
	GeneratePilot()
	GeneratePilot()
	GeneratePilot()
	GeneratePilot()
	pilotHpLabel.set_text(str(pilot_hp))
	hpLabel.set_text(str(hp))


func UpdateHp(changeValue):
	pilot_hp = pilot_hp + changeValue
	pilotHpLabel.set_text(str(pilot_hp))
	if pilot_hp==0:
		#todo hide task info and clear answer input
		change_ui_visibility(false, false)
		pilotCoolness.play("coolness_hidden")
		pilotName.set_text(NO_PILOT_HP)
		answerInput.text=""
	
		is_Task_Solved = false
		var cp = get_node("Pilot"+str(current_pilot+1))
		cp.visible = false
		UpdateHp(2)
		hp = hp - 1
		hpLabel.set_text(str(hp))
		if hp==0:
			lose()


func change_ui_visibility(is_apply_pilot_visible, is_apply_task_visible):
	pilotInfo.visible=is_apply_pilot_visible
	taskInfo.visible=is_apply_task_visible


func GeneratePilot():
	randomize()
	#создаем новое имя и аватар и заносим в словарь пилотов текущей сессии
	var rand_index = randi()%avatars_dict.size()
	var new_name = avatars_dict.keys()[rand_index]
	var new_avatar = avatars_dict.values()[rand_index]
	var coolness = coolness_arr[randi()%coolness_arr.size()]
	current_pilots[new_name] = [new_avatar, coolness]
	avatars_dict.erase(new_name)
	coolness_arr.erase(coolness)
	pilotPhoto.set_animation(current_pilots.values()[current_pilot][0])
	if current_pilots.size() <= 3: 
		current_pilot += 1
		pilotPhoto = get_node("Pilot"+str(current_pilot+1))


func generate_new_task():
	#applyPilotButton.set_disabled(true)
	change_ui_visibility(false, true)
	if is_Task_Solved == false :
		is_Task_Solved = true
		randomize()
		match current_pilots.values()[current_pilot][1] :
			"coolness_25":
				# удаляем предыдущую задачу, чтобы они не повторялись
				tasks_dict_25.erase(currentTaskText)
				currentTaskText = tasks_dict_25.keys()[randi()%tasks_dict_25.size()]
				taskLabel.set_text(currentTaskText)
			"coolness_50":
				tasks_dict_50.erase(currentTaskText)
				currentTaskText = tasks_dict_50.keys()[randi()%tasks_dict_50.size()]
				taskLabel.set_text(currentTaskText)
			"coolness_75":
				tasks_dict_75.erase(currentTaskText)
				currentTaskText = tasks_dict_75.keys()[randi()%tasks_dict_75.size()]
				taskLabel.set_text(currentTaskText)
			"coolness_100":
				tasks_dict_100.erase(currentTaskText)
				currentTaskText = tasks_dict_100.keys()[randi()%tasks_dict_100.size()]
				taskLabel.set_text(currentTaskText)


func select_pilot_1():
	select_pilot(0)


func select_pilot_2():
	select_pilot(1)


func select_pilot_3():
	select_pilot(2)


func select_pilot_4():
	select_pilot(3)


func select_pilot(index):
	if is_Task_Solved == false :
		change_ui_visibility(true, false)
		pilotName.set_text(current_pilots.keys()[index])
		pilotCoolness.play(current_pilots.values()[index][1])
		pilotTaskDifficulty.set_text(difficulty_dict[current_pilots.values()[index][1]])
		get_node("Pilot"+str(current_pilot+1)).stop()
		get_node("Pilot"+str(current_pilot+1)).set_frame(0)
		current_pilot = index
		get_node("Pilot"+str(current_pilot+1)).play()


func _on_LineEdit_text_changed(new_text):
	user_answer = new_text

func win():
	pilotCoolness.play("coolness_hidden")
	change_ui_visibility(false, false)
	pilotName.set_text(WIN)
	result.set_text(STAGE_FINISHED)

func lose():
	change_ui_visibility(false, false)
	pilotName.set_text(FAILURE)
	result.set_text(NO_HP)
	pilotHpLabel.set_text("0")


func check_answer():
	var coolnessCurrentTask = current_pilots.values()[current_pilot][1]
	match coolnessCurrentTask:
		"coolness_25":
			if tasks_dict_25[currentTaskText] == user_answer : win()
			else: UpdateHp(-1)
		"coolness_50":
			if tasks_dict_50[currentTaskText] == user_answer : win()
			else: UpdateHp(-1)
		"coolness_75":
			if tasks_dict_75[currentTaskText] == user_answer : win()
			else: UpdateHp(-1)
		"coolness_100":
			if tasks_dict_100[currentTaskText] == user_answer : win()
			else: UpdateHp(-1)
