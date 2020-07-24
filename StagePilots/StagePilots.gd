extends Control

var FAILURE="Не осталось попыток"
var NO_PILOT_HP="Выберай другого пилота"
var NO_HP="ПРОИГРАЛ"

onready var taskHeaderLabel = get_node("TaskHeader")
onready var taskLabel = get_node("Task")
onready var pilotPhoto = get_node("Pilot"+str(current_pilot+1))
onready var pilotName = get_node("Name")
onready var pilotCoolness = get_node("Coolness")
onready var pilotHpLabel = get_node("PilotHpText")
onready var hpLabel = get_node("HpText")

var current_pilots = { }
var current_pilot = 0
var currentTaskText = ""
var is_Task_Solved = false
var pilot_hp = 2
var hp = 2
var user_answer = ""

#массив имен и путей к персам
var avatars_dict = {
	"Вова" : "res://assets/stage_pilots/pilot_1.png",
	"Влад" : "res://assets/stage_pilots/pilot_2.png",
	"Даник" : "res://assets/stage_pilots/pilot_3.png",
	"Саша" : "res://assets/stage_pilots/pilot_4.png",
	"Егор" : "res://assets/stage_pilots/pilot_5.png",
	"Паша" : "res://assets/stage_pilots/pilot_6.png",
	"Чел" : "res://assets/stage_pilots/pilot_7.png",
	"Антон" : "res://assets/stage_pilots/pilot_8.png",
	"Вася" : "res://assets/stage_pilots/pilot_9.png",
	"Лёша" : "res://assets/stage_pilots/pilot_10.png",
	"ПАПА" : "res://assets/stage_pilots/pilot_11.png",
	"Дед" : "res://assets/stage_pilots/pilot_12.png"
}

var coolness_arr = [
	"20",
	"40",
	"60",
	"80"
]

var tasks_dict_20 = {
	"Легкая задача. Ответ на задание равен 0.":"0",
	"Легкая задача. Ответ на задание равен 1.":"1",
	"Легкая задача. Ответ на задание равен 2.":"2",
	"Легкая задача. Ответ на задание равен 3.":"3",
	"Легкая задача. Ответ на задание равен 4.":"4"
}
var tasks_dict_40 = {
	"Средняя задача. Ответ на задание равен 0.":"0",
	"Средняя задача. Ответ на задание равен 1.":"1",
	"Средняя задача. Ответ на задание равен 2.":"2",
	"Средняя задача. Ответ на задание равен 3.":"3",
	"Средняя задача. Ответ на задание равен 4.":"4"
}
var tasks_dict_60 = {
	"Сложная задача. Ответ на задание равен 0.":"0",
	"Сложная задача. Ответ на задание равен 1.":"1",
	"Сложная задача. Ответ на задание равен 2.":"2",
	"Сложная задача. Ответ на задание равен 3.":"3",
	"Сложная задача. Ответ на задание равен 4.":"4"
}
var tasks_dict_80 = {
	"Очень сложная задача. Ответ на задание равен 0.":"0",
	"Очень сложная задача. Ответ на задание равен 1.":"1",
	"Очень сложная задача. Ответ на задание равен 2.":"2",
	"Очень сложная задача. Ответ на задание равен 3.":"3",
	"Очень сложная задача. Ответ на задание равен 4.":"4"
}

func UpdateHp(changeValue):
	pilot_hp = pilot_hp + changeValue
	pilotHpLabel.set_text(str(pilot_hp))
	if pilot_hp==0:
		taskLabel.set_text(NO_PILOT_HP)
		is_Task_Solved = false
		var cp = get_node("Pilot"+str(current_pilot+1))
		cp.disabled = true
		cp.visible = false
		UpdateHp(2)
		hp = hp - 1
		hpLabel.set_text(str(hp))
		if hp==0:
			taskHeaderLabel.set_text(FAILURE)
			taskLabel.set_text(NO_HP)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	GeneratePilot()
	pilotName.set_text(current_pilots.keys()[0])
	pilotCoolness.set_text(current_pilots.values()[0][1])
	GeneratePilot()
	GeneratePilot()
	GeneratePilot()

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
	
	pilotPhoto.texture_normal = load(current_pilots.values()[current_pilot][0])
	if(current_pilots.size() <= 3): 
		current_pilot += 1
		pilotPhoto = get_node("Pilot"+str(current_pilot+1))

func generate_new_task():
	if is_Task_Solved == false :
		is_Task_Solved = true
		randomize()
		match current_pilots.values()[current_pilot][1] :
			"20":
				# удаляем предыдущую задачу, чтобы они не повторялись
				tasks_dict_20.erase(currentTaskText)
				currentTaskText = tasks_dict_20.keys()[randi()%tasks_dict_20.size()]
				taskLabel.set_text(currentTaskText)
			"40":
				# удаляем предыдущую задачу, чтобы они не повторялись
				tasks_dict_40.erase(currentTaskText)
				currentTaskText = tasks_dict_40.keys()[randi()%tasks_dict_40.size()]
				taskLabel.set_text(currentTaskText)
			"60":
				# удаляем предыдущую задачу, чтобы они не повторялись
				tasks_dict_60.erase(currentTaskText)
				currentTaskText = tasks_dict_60.keys()[randi()%tasks_dict_60.size()]
				taskLabel.set_text(currentTaskText)
			"80":
				# удаляем предыдущую задачу, чтобы они не повторялись
				tasks_dict_80.erase(currentTaskText)
				currentTaskText = tasks_dict_80.keys()[randi()%tasks_dict_80.size()]
				taskLabel.set_text(currentTaskText)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func select_pilot_1():
	if is_Task_Solved == false :
		pilotName.set_text(current_pilots.keys()[0])
		pilotCoolness.set_text(current_pilots.values()[0][1])
		current_pilot = 0
func select_pilot_2():
	if is_Task_Solved == false :
		pilotName.set_text(current_pilots.keys()[1])
		pilotCoolness.set_text(current_pilots.values()[1][1])
		current_pilot = 1
func select_pilot_3():
	if is_Task_Solved == false :
		pilotName.set_text(current_pilots.keys()[2])
		pilotCoolness.set_text(current_pilots.values()[2][1])
		current_pilot = 2
func select_pilot_4():
	if is_Task_Solved == false :
		pilotName.set_text(current_pilots.keys()[3])
		pilotCoolness.set_text(current_pilots.values()[3][1])
		current_pilot = 3


func _on_LineEdit_text_changed(new_text):
	user_answer = new_text


func check_answer():
	var coolnessCurrentTask = current_pilots.values()[current_pilot][1]
	match coolnessCurrentTask:
		"20":
			if tasks_dict_20[currentTaskText] == user_answer :
				pilotName.set_text("КРУТОЙ")
			else: UpdateHp(-1)
		"40":
			if tasks_dict_40[currentTaskText] == user_answer :
				pilotName.set_text("КРУТОЙ")
			else: UpdateHp(-1)
		"60":
			if tasks_dict_60[currentTaskText] == user_answer :
				pilotName.set_text("КРУТОЙ")
			else: UpdateHp(-1)
		"80":
			if tasks_dict_80[currentTaskText] == user_answer :
				pilotName.set_text("КРУТОЙ")
			else: UpdateHp(-1)
