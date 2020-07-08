extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# todo число попыток + интерфейс с попытками
var LAST_TASK=5
var TASKS_SOLVED="Поздравляем, ракета спроектирована!"
var currentTask = 1
var currentTaskText = ""
var userAnswer = ""
var isTaskGenerated = true
onready var taskLabel = get_node("TaskContainer/Task")
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
	GenerateNewTask()

func _on_Answer_text_changed(new_text):
	userAnswer = new_text

func _on_rocket_animation_finished():
	if !isTaskGenerated:
		GenerateNewTask()
	if currentTask==LAST_TASK+1:
		FinishStage()
		

func FinishStage():
	taskLabel.set_text("Поздравляем, задачи решены!")
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

func CheckAnswer():
	if tasks_dict[currentTaskText] == userAnswer:
		print("correct")
		get_node("Answer").set_text("")
		NextTask()
	else:
		# todo вычитать попытки
		print("вычитать попытки")
		get_node("task_"+str(currentTask)).play("wrong")
		get_node("task_"+str(currentTask)+"_line").play("wrong")

	
