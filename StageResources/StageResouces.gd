extends Node2D

class ChestInfo:
	var task = "Условие задачи"
	var answer = "1"
	var answer_variants = ["1","2","3"]  # 3 answer variants
	
	func _init(task, answer, answer_variants):
		self.task = task
		self.answer = answer
		self.answer_variants = answer_variants
	

const Player = preload("res://StageResources/Player.tscn")
const Chest = preload("res://StageResources/Chest.tscn")
const CHESTS_COUNT = 5
const CHESTS_TO_COLLECT = 3

var chest_tasks = [
	ChestInfo.new("Задача с ответом 1","1",["1","2","3"]),
	ChestInfo.new("Задача с ответом 4","4",["6","5","4"]),
	ChestInfo.new("Задача с ответом 7","7",["7","8","9"]),
	ChestInfo.new("Задача с ответом 10","10",["11","10","12"]),
	ChestInfo.new("Задача с ответом 13","13",["13","14","15"])
]
var chest_positions = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
const PLAYER_POSITIONS = ["1", "2", "3", "4"]


# Called when the node enters the scene tree for the first time.
func _ready():
	set_player_pos()
	$Ui/StatsBg/Ammo.text=str($Map/Player.bullets)
	spawn_chests(CHESTS_COUNT)

func set_player_pos():
	randomize()
	var rand_index = randi()%PLAYER_POSITIONS.size()
	var pos = PLAYER_POSITIONS[rand_index]
	var spawner = $Map/PlayerPositions.get_node("Position"+pos)
	$Map/Player.global_position.x=spawner.global_position.x
	$Map/Player.global_position.y=spawner.global_position.y

func spawn_chests(chests_count):
	for i in range(1,CHESTS_COUNT+1):
		randomize()
		var pos_index = randi()%chest_positions.size()
		var position = chest_positions[pos_index]
		chest_positions.remove(pos_index)
		
		randomize()
		var task_index = randi()%chest_tasks.size()
		var chestInfo = chest_tasks[task_index]
		chest_tasks.remove(task_index)
		spawn_chest(position, chestInfo)

func spawn_chest(pos, chest_info:ChestInfo):
	var chest = Chest.instance()
	chest.get_node("UI/Task/Text").set_text(chest_info.task)
	for i in range(0, chest_info.answer_variants.size()):
		chest.get_node("UI/Task/Node/Variant"+str(i+1)).set_text(chest_info.answer_variants[i])
	var spawner = $Map/Chests.get_node("Position"+pos)
	#todo fix /5 issue
	chest.correct_answer = chest_info.answer
	chest.answer_variants = chest_info.answer_variants
	chest.global_position.x=spawner.global_position.x/5
	chest.global_position.y=spawner.global_position.y/5
	$Map/Chests.add_child(chest)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#update bullets amount
func _on_Player_change_bullets_count(bullets):
	$Ui/StatsBg/Ammo.text=str(bullets)
