extends Control
 
const tasks_dict_25 = {
	"В классе 26 учащихся, среди них два друга — Андрей и Сергей. Учащихся случайным образом разбивают на 2 равные группы. Найдите вероятность того, что Андрей и Сергей окажутся в одной группе.":"0,48",
	"В фирме такси в наличии 50 легковых автомобилей; 27 из них чёрного цвета с жёлтыми надписями на бортах, остальные — жёлтого цвета с чёрными надписями. Найдите вероятность того, что на случайный вызов приедет машина жёлтого цвета с чёрными надписями.":"0,46",
	"В группе туристов 30 человек. Их вертолётом в несколько приёмов забрасывают в труднодоступный район по 6 человек за рейс. Порядок, в котором вертолёт перевозит туристов, случаен. Найдите вероятность того, что турист П. полетит первым рейсом вертолёта.":"0,2",
	"Вероятность того, что новый DVD-проигрыватель в течение года поступит в гарантийный ремонт, равна 0,045. В некотором городе из 1000 проданных DVD-проигрывателей в течение года в гарантийную мастерскую поступила 51 штука. На сколько отличается частота события «гарантийный ремонт» от его вероятности в этом городе?":"0,006",
	"Механические часы с двенадцатичасовым циферблатом в какой-то момент сломались и перестали идти. Найдите вероятность того, что часовая стрелка остановилась, достигнув отметки 10, но не дойдя до отметки 1.":"0,25"
}
 
const tasks_dict_50 = {
	"Из урны, содержащей 10 белых и 15 черных шаров, наугад одновременно извлекают восемь шаров. Сколько в среднем шаров будет среди них?":"3.2",
	"Сколько в среднем шестерок выпадает при подбрасывании шести игральных костей?":"1",
	"Книга в 500 страниц содержит 400 опечаток. Предположим, что каждая из них независимо от остальных опечаток может с одинаковыми вероятностями оказаться на любой странице книги. Оценить вероятность того, что на 13-й странице будет не менее двух опечаток. Ответ дать с точностью до сотых(0,01)":"0,19",
	"На стороне AB = 1 равностороннего треугольника ABC наугад выбирается точка M. Найти дисперсию площади треугольника AMC. Ответ дать простой дробью(например: 1/2)":"1/64",
	"Вычислить вероятность попадания случайной величины ξ ~ Ν (1,4) в промежуток (-3,1)":"0,477"
}
 
const tasks_dict_75 = {
	"Какое минимальное число резервных блоков нужно подключить параллельно к основному <<экспоненциальному>> блоку, чтобы средний срок безотказный работы устройства вырос не менее, чем в два раза?":"3",
	"В некотором городе каждый день с вероятностью 0,6 ясно и с вероятностью 0,4 пасмурно (независимо от погоды в другие дни). Какое в среднем минимальное число дней нужно прожить в этом городе, чтобы увидеть его в ясный, и в пасмурный день? Ответ дать простой дробью, не выделяя целую часть(например: 8/3)":"19/6",
	"Игральную кость подбрасывают до тех пор, пока не выпадет шестерка. Пусть S - сумма всех выпавших при этом очков. Найти MS.":"21",
	"Сколько раз в среднем придется бросать игральную кость до выпадания серии 666?":"258",
	"Игральную кость подбрасывают до тех пор, пока не выпадет четное число очков. Чему равно среднее значение суммы всех выпавших очков?":"7"
}
 
const tasks_dict_100 = {
	"Вычислить коэффициент корреляции между числом выпадений единицы и числом выпадений шестерки при n >= 11 подбрасываниях игральной кости.":"-0,2",
	"Пусть 'сигма' и 'ню' - соответственно число гербов и число решек, выпадающих при бросании ста монет. Найдите ковариацию этих величин.":"-25",
	"В лифт 9-этажного дома на первом этаже вошли 10 человек. Пусть 'сигма' - число тех из них, которые выходят на пятом этаже, а 'ню' - число тех из них, которые выходят на следующих этажах. Вычислите квадрат ковариации случайных величин 'сигма' и 'ню'. Ответ дайте простой дробью.":"1/7",
	"Пусть 'кси' ~ N(0,1). Вычислите коэффициент корреляции случайных величин 'сигма' и 'ню', если 'сигма' = 'кси', 'ню' = 'кси'^2.":"0",
	"На отрезок [0, 'ню'] наугад бросают m точек. Предполагая, что n>= 2, m >= 1, вычислите коэффициент корреляции между числом 'сигма' точек, попавших на отрезок [0,1], и числом 'ню' точек, попавших на отрезок [n-1,n]":"-1/(n-1)"
}

const coolness_arr = [
	"coolness_25",
	"coolness_50",
	"coolness_75",
	"coolness_100"
]

const all_tasks_dict = {
	coolness_arr[0] : tasks_dict_25,
	coolness_arr[1] : tasks_dict_50,
	coolness_arr[2] : tasks_dict_75,
	coolness_arr[3] : tasks_dict_100
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

