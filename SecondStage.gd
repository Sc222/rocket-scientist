extends Control

var LAST_TASK=5
var TASK_HP_BONUS=2
var TASKS_SOLVED="Поздравляем, ракета спроектирована!"

var hp = 2
var currentTask = 1
var currentTaskText = ""
var userAnswer = ""
var isTaskGenerated = true
onready var taskLabel = get_node("TaskContainer/Task")
onready var hpLabel = get_node("HpText")
onready var rocket = get_node("rocket")


var tasks_dict = {
	"Здесь будет условие задания. Ответ на задание равен 0.":"0",
	"Здесь будет условие задания. Ответ на задание равен 1.":"1",
	"Здесь будет условие задания. Ответ на задание равен 2.":"2",
	"Здесь будет условие задания. Ответ на задание равен 3.":"3",
	"Здесь будет условие задания. Ответ на задание равен 4.":"4",

}

# Called when the node enters the scene tree for the first time.
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

func FinishStage():
	taskLabel.set_text("Поздравляем, ракета спроектирована.")
	#todo сделать кнопку "следующий этап" и сделать ее видимой

func GenerateNewTask():
	isTaskGenerated=true
	randomize()
	# удаляем предыдущую задачу, чтобы они не повторялись
	tasks_dict.erase(currentTaskText) 
	currentTaskText = tasks_dict.keys()[randi()%tasks_dict.size()]
	taskLabel.set_text(currentTaskText)

func NextTask():
		get_node("task_"+str(currentTask)).play("complete")
		get_node("task_"+str(currentTask)+"_line").play("complete")
		if currentTask!=LAST_TASK:
			isTaskGenerated=false
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
	if currentTask!=LAST_TASK+1:
		if tasks_dict[currentTaskText] == userAnswer:
			UpdateHp(TASK_HP_BONUS)
			print("correct")
			get_node("Answer").set_text("")
			NextTask()
		else:
			UpdateHp(-1)
			# todo вычитать попытки
			print("вычитать попытки")
			SetError()

	
