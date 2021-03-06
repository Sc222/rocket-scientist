extends Node2D

signal chests_placed

class ChestInfo:
	
	var task = ""
	var answer = ""
	var answer_variants = []
	
	func _init(task_val, answer_val, answer_variants_val):
		self.task = task_val
		self.answer = answer_val
		self.answer_variants = answer_variants_val


const Player = preload("res://StageResources/Player/Player.tscn")
const Chest = preload("res://StageResources/Chest/Chest.tscn")
const Monster = preload("res://StageResources/Monster/Monster.tscn")
const CHESTS_COUNT = 5
const CHESTS_TO_COLLECT = 3
const MAX_MONSTERS = 3
const PLAYER_POSITIONS = ["1", "2", "3", "4"]
var chest_positions = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
var chest_tasks = [
	ChestInfo.new("Есть пять шаров, два из них чёрные. Какова вероятность вытащить НЕ черный шар.","0,6",["0,6","0,4","0,36"]),
	ChestInfo.new("В случайном эксперименте бросают две игральные кости. Найдите вероятность того, что в сумме выпадет 8 очков.","0,14",["0,8","0,14","0,2"]),
	ChestInfo.new("В случайном эксперименте симметричную монету бросают трижды. Найдите вероятность того, что выпадет хотя бы две решки.","0,5",["0,1","0,5","1"]),
	ChestInfo.new("Вася, Петя, Коля и Лёша бросили жребий — кому начинать игру. Найдите вероятность того, что начинать игру должен будет Петя.","0,25",["0,25","0,1","0,75"]),
	ChestInfo.new("Из множества натуральных чисел от 10 до 19 наудачу выбирают одно число. Какова вероятность того, что оно делится на 3?","0,3",["0,3","0,35","0,48"])
]
var monsters_on_map = 0
var is_stage_completed = false


func _ready():
	get_tree().paused = false
	Global.current_stage = Global.STAGE.RESOURCES
	setup_navigation()
	
	set_player_pos()
	update_ui($Map/Player)
	spawn_chests(CHESTS_COUNT)


func setup_navigation():
	self.connect("chests_placed", $Navigation2D,"on_chests_placed")


func update_ui(player):
	$UI/StatsBg/Hp.text=str(player.hp)
	$UI/StatsBg/Coins.text=str(player.coins)+"/"+str(player.COINS_TO_COLLECT)


func set_player_pos():
	randomize()
	var rand_index = randi()%PLAYER_POSITIONS.size()
	var pos = PLAYER_POSITIONS[rand_index]
	var spawner = $Map/PlayerPositions.get_node("Position"+pos)
	$Map/Player.global_position.x=spawner.global_position.x
	$Map/Player.global_position.y=spawner.global_position.y


func spawn_chests(chests_count):
	for _i in range(1, chests_count+1):
		randomize()
		var pos_index = randi()%chest_positions.size()
		var position = chest_positions[pos_index]
		chest_positions.remove(pos_index)
		
		randomize()
		var task_index = randi()%chest_tasks.size()
		var chestInfo = chest_tasks[task_index]
		chest_tasks.remove(task_index)
		spawn_chest(position, chestInfo)
	emit_signal("chests_placed")


func spawn_chest(pos, chest_info:ChestInfo):
	var chest = Chest.instance()
	chest.get_node("UI/Task/Text").set_text(chest_info.task)
	for i in range(0, chest_info.answer_variants.size()):
		chest.get_node("UI/Task/Node/Variant"+str(i+1)).set_text(chest_info.answer_variants[i])
	var spawner = $Map/ChestPositions.get_node("Position"+pos)
	chest.correct_answer = chest_info.answer
	chest.connect("send_answer",self,"_on_Chest_send_answer")
	chest.answer_variants = chest_info.answer_variants
	$Map/Chests.add_child(chest)
	chest.global_position.x=spawner.global_position.x
	chest.global_position.y=spawner.global_position.y


# receive signal from the chest and update player
func _on_Chest_send_answer(is_correct):
	if is_stage_completed:
		return	
	print("CHEST SEND ANSWER")
	Global.tries+=1
	Global.tasks_total+=1
	if is_correct:
		Global.solved_tasks+=1
		$Map/Player.collect_coin()
	else:
		$Map/Player.hit()
	update_ui($Map/Player)


func _on_Player_change_hp():
	update_ui($Map/Player)


func _on_Player_die():
	complete_stage(false)


func _on_Player_win():
	complete_stage(true)


func complete_stage(is_success):
	if is_stage_completed:
		return
	is_stage_completed = true
	get_tree().paused=true
	if is_success:
		$UI/NextStageDialog.show_dialog(0)
	else:
		$UI/GameOverDialog.show_dialog(0, Global.solved_tasks, Global.tasks_total, Global.tries)


func _on_MonsterSpawnTimer_timeout():
	if monsters_on_map < MAX_MONSTERS:
		spawn_monster()


func spawn_monster():
	var spawners = get_visible_monster_spawners()
	randomize()
	var rand_index = randi()%spawners.size()
	var spawner = spawners[rand_index]
	var monster = Monster.instance()
	monster.init($Map/Player, $Navigation2D)
	monsters_on_map+=1
	monster.connect("die",self,"_on_Monster_die")
	$Map/Monsters.add_child(monster)
	monster.global_position.x=spawner.global_position.x
	monster.global_position.y=spawner.global_position.y
	

func _on_Monster_die():
	monsters_on_map-=1


func get_visible_monster_spawners():
	var spawners = $Map/MonsterPositions.get_children()
	var result = []
	for i in range(0, spawners.size()):
		if spawners[i].get_node("VisibilityNotifier").is_on_screen():
			result.append(spawners[i])
			print("visible: "+str(i))
	return result

