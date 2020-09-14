extends Control

const tasks_dict_25 = {
	"Легкая задача. Ответ на задание равен 0.":"0",
	"Легкая задача. Ответ на задание равен 1.":"1",
	"Легкая задача. Ответ на задание равен 2.":"2",
	"Легкая задача. Ответ на задание равен 3.":"3",
	"Легкая задача. Ответ на задание равен 4.":"4"
}

const tasks_dict_50 = {
	"Средняя задача. Ответ на задание равен 0.":"0",
	"Средняя задача. Ответ на задание равен 1.":"1",
	"Средняя задача. Ответ на задание равен 2.":"2",
	"Средняя задача. Ответ на задание равен 3.":"3",
	"Средняя задача. Ответ на задание равен 4.":"4"
}

const tasks_dict_75 = {
	"Сложная задача. Ответ на задание равен 0.":"0",
	"Сложная задача. Ответ на задание равен 1.":"1",
	"Сложная задача. Ответ на задание равен 2.":"2",
	"Сложная задача. Ответ на задание равен 3.":"3",
	"Сложная задача. Ответ на задание равен 4.":"4"
}

const tasks_dict_100 = {
	"Очень сложная задача. Ответ на задание равен 0.":"0",
	"Очень сложная задача. Ответ на задание равен 1.":"1",
	"Очень сложная задача. Ответ на задание равен 2.":"2",
	"Очень сложная задача. Ответ на задание равен 3.":"3",
	"Очень сложная задача. Ответ на задание равен 4.":"4"
}

const coolness_arr = [
	"coolness_25",
	"coolness_50",
	"coolness_75",
	"coolness_100"
]

const all_tasks_dict = {
	coolness_arr[0] : tasks_dict_25,
	coolness_arr[1] : tasks_dict_25,
	coolness_arr[2] : tasks_dict_25,
	coolness_arr[3] : tasks_dict_25
}

const flight_hp_bonus_dict = {
	coolness_arr[0] : 1,
	coolness_arr[1] : 2,
	coolness_arr[2] : 3,
	coolness_arr[3] : 4
}

const difficulty_dict = {
	coolness_arr[0] : "Простая",
	coolness_arr[1] : "Средняя",
	coolness_arr[2] : "Сложная",
	coolness_arr[3] : "Очень сложная"
}

# словарь имен и анимаций
const avatars_dict = {
	"Такенори Кайягаки" : "pilot_1",
	"Иван Андреев" : "pilot_2",
	"Изабелла Коллинз" : "pilot_3",
	"Виктория Иванова" : "pilot_4",
	"Дмитрий Игнатов" : "pilot_5",
	"Сьюзан Ли" : "pilot_6",
	"Анонимус" : "pilot_7",
	"Йозеф Кнехт" : "pilot_8",
	"Утано Сакайя" : "pilot_9",
	"Незнакомец в шляпе" : "pilot_10",
	"Сохо Акигава" : "pilot_11",
	"Стефани Гонзалес" : "pilot_12"
}


const NO_PILOT_HP="Выберите другого пилота"
const NO_HP="Не осталось попыток"
const LOSE="Поражение"
const WIN="Победа"
const PILOTS_COUNT = 4
var current_pilots = { }
var current_pilot = 0
var current_task_text = ""
var is_task_solved = false
var pilot_hp = 2
var hp = 2
var user_answer = ""
var is_stage_completed = false
onready var pilot_photo = get_node("Pilot"+str(current_pilot+1))


func _ready():
	get_tree().paused = false
	Global.current_stage = Global.STAGE.PILOTS
	change_ui_visibility(false, false)
	for _i in range(0,PILOTS_COUNT):
		generate_pilot()
	$Tries/PilotHpText.set_text(str(pilot_hp))
	$Tries/HpText.set_text(str(hp))


func update_hp(changeValue):
	pilot_hp = pilot_hp + changeValue
	$Tries/PilotHpText.set_text(str(pilot_hp))
	if pilot_hp==0:
		change_pilots_state(false) #enable pilots select
		change_ui_visibility(false, false)
		$Coolness.play("coolness_hidden")
		$CoolnessInfo.visible=false
		$Name.set_text(NO_PILOT_HP)
		$TaskInfo/ApplyTask/AnswerLineEdit.text=""
		is_task_solved = false
		var cp = get_node("Pilot"+str(current_pilot+1))
		cp.visible = false
		update_hp(2)
		hp = hp - 1
		$Tries/HpText.set_text(str(hp))
		if hp==0:
			complete_stage(false)


func change_ui_visibility(is_apply_pilot_visible, is_apply_task_visible):
	$PilotInfo.visible=is_apply_pilot_visible
	$TaskInfo.visible=is_apply_task_visible


func generate_pilot():
	randomize()
	# создаем новое имя и аватар и заносим в словарь пилотов текущей сессии
	var rand_index = randi()% avatars_dict.size()
	var new_name = avatars_dict.keys()[rand_index]
	var new_avatar = avatars_dict.values()[rand_index]
	var coolness = coolness_arr[randi()%coolness_arr.size()]
	current_pilots[new_name] = [new_avatar, coolness]
	avatars_dict.erase(new_name)
	coolness_arr.erase(coolness)
	pilot_photo.set_animation(current_pilots.values()[current_pilot][0])
	if current_pilots.size() <= 3: 
		current_pilot += 1
		pilot_photo = get_node("Pilot"+str(current_pilot+1))


func select_pilot(index):
	if not is_task_solved:
		if current_pilot==index and get_node("Pilot"+str(current_pilot+1)).get_frame() ==1:
			return  # pilot was already selected
		change_ui_visibility(true, false)
		$Name.set_text(current_pilots.keys()[index])
		$Coolness.play(current_pilots.values()[index][1])
		$CoolnessInfo.visible=true
		$PilotInfo/Bg/Difficulty.set_text(difficulty_dict[current_pilots.values()[index][1]])
		get_node("Pilot"+str(current_pilot+1)).stop()
		get_node("Pilot"+str(current_pilot+1)).set_frame(0)
		current_pilot = index
		get_node("Pilot"+str(current_pilot+1)).play()


func complete_stage(is_success):
	if is_stage_completed:
		return
	is_stage_completed = true
	get_tree().paused=true
	$Coolness.play("coolness_hidden")
	$CoolnessInfo.visible=false
	change_ui_visibility(false, false)
	if is_success:
		$Name.set_text(WIN)
		
		$UI/NextStageDialog.show_dialog(2)
	else:
		$Name.set_text(LOSE)
		$UI/GameOverDialog.show_dialog(2,Global.solved_tasks, Global.tasks_total, Global.tries)


func generate_new_task():
	Global.tasks_total+=1
	change_pilots_state(true)  # disable pilots select
	change_ui_visibility(false, true)
	if not is_task_solved:
		var current_task_coolness = current_pilots.values()[current_pilot][1]
		
		var tasks_coolness_dict = all_tasks_dict[current_task_coolness]
		
		# словарь - ссылочный тип данных, поэтому tasks_dict_** тоже очищается
		# очистка словаря чтобы задачки не повторялись
		tasks_coolness_dict.erase(current_task_text)

		randomize()
		current_task_text = tasks_coolness_dict.keys()[randi()%tasks_coolness_dict.size()]
		$TaskInfo/Bg/TaskContainer/Task.set_text(current_task_text)


func change_pilots_state(is_disabled):
	for i in range (1, PILOTS_COUNT+1):
		get_node("Pilot"+str(i)+"/ButtonPilot"+str(i)).set_disabled(is_disabled)


func check_answer():
	Global.tries+=1
	var current_task_coolness = current_pilots.values()[current_pilot][1]
	var tasks_coolness_dict = all_tasks_dict[current_task_coolness]
	if tasks_coolness_dict[current_task_text] == user_answer:
		Global.solved_tasks+=1
		Global.final_stage_hp = flight_hp_bonus_dict[current_task_coolness]
		complete_stage(true)
	else:
		update_hp(-1)


func _on_LineEdit_text_changed(new_text):
	user_answer = new_text


func select_pilot_1():
	select_pilot(0)


func select_pilot_2():
	select_pilot(1)


func select_pilot_3():
	select_pilot(2)


func select_pilot_4():
	select_pilot(3)

