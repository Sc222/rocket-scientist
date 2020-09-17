extends Control

const LAST_TASK=5
const TASK_HP=2
const TASK="Задача"
const PROCESS="Проектирование"
const WIN="Победа"
const COMPLETED="Поздравляем, ракета спроектирована"
const LOSE="Поражение"
const NOT_COMPLETED="К сожалению, ракета не удалось спроектировать"
const PROCESSING=[
	"Проектируем первый двигатель...",
	"Проектируем второй двигатель...",
	"Проектируем первую ступень ракеты...",
	"Проектируем кабину...",
	"Проектируем вторую ступень ракеты..."
	]
var tasks_dict = {
	"В кармане у Миши было четыре конфеты — «Грильяж», «Белочка», «Коровка» и «Ласточка», а также ключи от квартиры. Вынимая ключи, Миша случайно выронил из кармана одну конфету. Найдите вероятность того, что потерялась конфета «Грильяж».":"0,25",
	"Если шахматист А. играет белыми фигурами, то он выигрывает у шахматиста Б. с вероятностью 0,52. Если А. играет черными, то А. выигрывает у Б. с вероятностью 0,3. Шахматисты А. и Б. играют две партии, причём во второй партии меняют цвет фигур. Найдите вероятность того, что А. выиграет оба раза.":"0,156",
	"На экзамен вынесено 60 вопросов, Андрей не выучил 3 из них. Найдите вероятность того, что ему попадется выученный вопрос.":"0,95",
	"Вероятность того, что батарейка бракованная, равна 0,06. Покупатель в магазине выбирает случайную упаковку, в которой две таких батарейки. Найдите вероятность того, что обе батарейки окажутся исправными.":"0,8836",
	"В среднем из 1400 садовых насосов, поступивших в продажу, 7 подтекают. Найдите вероятность того, что один случайно выбранный для контроля насос не подтекает.":"0,995"
}
var hp = 2
var current_task = 1
var current_task_text = ""
var user_answer = ""
var is_task_generated = true
var is_stage_completed = false


func _ready():
	get_tree().paused = false
	update_hp(0)
	Global.tasks_total+=1
	Global.current_stage = Global.STAGE.DESIGN
	generate_next_task()


func update_hp(change_val):
	hp=hp+change_val
	$HpBackground/HpText.set_text(str(hp))
	if hp==0:
		complete_stage(false)


func complete_stage(is_success):
	if is_stage_completed:
		return
	is_stage_completed = true
	get_tree().paused=true
	if is_success:
		$TaskHeader.set_text(WIN)
		$TaskContainer/Task.set_text(COMPLETED)
		$UI/NextStageDialog.show_dialog(1)
	else:
		$TaskHeader.set_text(LOSE)
		$TaskContainer/Task.set_text(NOT_COMPLETED)
		$UI/GameOverDialog.show_dialog(1, Global.solved_tasks, Global.tasks_total, Global.tries)


func generate_next_task():
	is_task_generated=true
	randomize()
	# удаляем предыдущую задачу, чтобы они не повторялись
	tasks_dict.erase(current_task_text) 
	current_task_text = tasks_dict.keys()[randi()%tasks_dict.size()]
	$TaskHeader.set_text(TASK)
	$TaskContainer/Task.set_text(current_task_text)


func next_task():
		$AnswerContainer/Answer.set_text("")
		get_node("Task"+str(current_task)).play("complete")
		get_node("Task"+str(current_task)+"Line").play("complete")
		$TaskContainer/Task.set_text(PROCESSING[current_task-1])
		$TaskHeader.set_text(PROCESS)
		if current_task!=LAST_TASK:
			is_task_generated=false
			update_hp(TASK_HP-hp)
			get_node("Task"+str(current_task+1)).play("unlock")
			get_node("Task"+str(current_task+1)+"Line").play("unlock")
		$Rocket.play("task_"+str(current_task))
		current_task+=1


func show_error():
	var task_button = get_node("Task"+str(current_task))
	var task_line = get_node("Task"+str(current_task)+"Line")
	task_button.frame = 0
	task_line.frame = 0
	task_button.play("wrong")
	task_line.play("wrong")
	

func check_answer():
	if is_task_generated and current_task!=LAST_TASK+1 and hp>0:
		Global.tries+=1
		if tasks_dict[current_task_text] == user_answer:
			Global.solved_tasks+=1
			Global.tasks_total+=1
			next_task()
		else:
			update_hp(-1)
			show_error()


func _on_ApplyAnswer_pressed():
	check_answer()


func _on_Answer_text_changed(new_text):
	user_answer = new_text


func _on_rocket_animation_finished():
	if !is_task_generated:
		generate_next_task()
	if current_task==LAST_TASK+1:
		complete_stage(true)

