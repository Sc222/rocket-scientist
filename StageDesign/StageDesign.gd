extends Control

var LAST_TASK=5
var TASK_HP_BONUS=2
var WIN="Победа"
var COMPLETED="Поздравляем, ракета спроектирована"
var FAILURE="Поражение"
var NO_HP="Не осталось попыток"
var PROCESSING=[
	"Проектируем первый двигатель...",
	"Проектируем второй двигатель...",
	"Проектируем первую ступень ракеты...",
	"Проектируем кабину...",
	"Проектируем вторую ступень ракеты..."
	]
var TASK="Задача"
var PROCESS="Проектирование"

var hp = 2
var currentTask = 1
var currentTaskText = ""
var userAnswer = ""
var isTaskGenerated = true
onready var taskHeaderLabel = get_node("TaskHeader")
onready var taskLabel = get_node("TaskContainer/Task")
onready var hpLabel = get_node("HpText")
onready var rocket = get_node("rocket")


var tasks_dict = {
	"Здесь будет условие задания. Ответ на задание равен 0.":"0",
	"Здесь будет условие задания. Ответ на задание равен 1.":"1",
	"Здесь будет условие задания. Ответ на задание равен 2.":"2",
	"Здесь будет условие задания. Ответ на задание равен 3.":"3",
	"Здесь будет условие задания. Ответ на задание равен 4.":"4"
}

func _ready():
	UpdateHp(0)
	GenerateNewTask()

func _on_Answer_text_changed(new_text):
	userAnswer = new_text

func _on_rocket_animation_finished():
	if !isTaskGenerated:
		GenerateNewTask()
	if currentTask==LAST_TASK+1:
		FinishStage()
		

func UpdateHp(changeValue):
	hp=hp+changeValue
	hpLabel.set_text(str(hp))
	if hp==0:
		taskHeaderLabel.set_text(FAILURE)
		taskLabel.set_text(NO_HP)

func FinishStage():
	taskHeaderLabel.set_text(WIN)
	taskLabel.set_text(COMPLETED)
	#todo сделать кнопку "следующий этап" и сделать ее видимой

func GenerateNewTask():
	isTaskGenerated=true
	randomize()
	# удаляем предыдущую задачу, чтобы они не повторялись
	tasks_dict.erase(currentTaskText) 
	currentTaskText = tasks_dict.keys()[randi()%tasks_dict.size()]
	taskHeaderLabel.set_text(TASK)
	taskLabel.set_text(currentTaskText)

func NextTask():
		get_node("Answer").set_text("")
		get_node("task_"+str(currentTask)).play("complete")
		get_node("task_"+str(currentTask)+"_line").play("complete")
		taskLabel.set_text(PROCESSING[currentTask-1])
		taskHeaderLabel.set_text(PROCESS)
		if currentTask!=LAST_TASK:
			isTaskGenerated=false
			UpdateHp(TASK_HP_BONUS)
			get_node("task_"+str(currentTask+1)).play("unlock")
			get_node("task_"+str(currentTask+1)+"_line").play("unlock")
		rocket.play("task_"+str(currentTask))
		currentTask=currentTask+1

func SetError():
	# todo вычитать попытки
	var taskButton = get_node("task_"+str(currentTask))
	var taskLine = get_node("task_"+str(currentTask)+"_line")
	taskButton.frame = 0
	taskLine.frame = 0
	taskButton.play("wrong")
	taskLine.play("wrong")
	

func CheckAnswer():
	if isTaskGenerated and currentTask!=LAST_TASK+1 and hp>0:
		if tasks_dict[currentTaskText] == userAnswer:
			print("correct")
			NextTask()
		else:
			UpdateHp(-1)
			# todo вычитать попытки
			print("вычитать попытки")
			SetError()

	
