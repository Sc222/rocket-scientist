extends Node2D

signal send_answer(is_correct)
var is_player_nearby = false
var chest_state = CHEST_STATE.CLOSED
var correct_answer = ""
var answer_variants = []
const CORRECT_ANSWER = "Правильный ответ!"
const WRONG_ANSWER = "Вы ошиблись!"
enum CHEST_STATE { OPENED, CLOSED, WAIT_FOR_ANSWER, EXPLODED } 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_player_nearby and chest_state == CHEST_STATE.CLOSED:
		#$Sprite.play("opened")
		#is_closed = false
		if Input.is_action_just_pressed("player_action"):
			$UI/Info.visible = false
			$UI/Task.visible = true
			chest_state = CHEST_STATE.WAIT_FOR_ANSWER
	
	if is_player_nearby and chest_state == CHEST_STATE.WAIT_FOR_ANSWER:
		check_answer()


func check_answer():
	for i in range(0, answer_variants.size()):
		var is_answer_selected = Input.is_action_just_pressed("select_answer_"+str(i+1))
		if is_answer_selected:
			var answer = str(answer_variants[i])
			var is_correct_answer = answer == correct_answer
			if is_correct_answer:
				$Sprite.play("opened")
				chest_state = CHEST_STATE.OPENED
				print("emit signal correct answer")
			else:
				$Sprite.play("exploded")
				chest_state = CHEST_STATE.EXPLODED
				print("emit signal wrong answer")
			show_result_message(is_correct_answer)
			emit_signal("send_answer", is_correct_answer)
			break


func show_result_message(is_correct):
	$UI/Info.visible = true
	$UI/Task.visible = false
	if is_correct:
		$UI/Info.text = CORRECT_ANSWER
	else:
		$UI/Info.text = WRONG_ANSWER


func _on_ChestArea_body_entered(body):
	if body.is_in_group("player") and chest_state == CHEST_STATE.CLOSED:
		is_player_nearby = true
		$UI/Info.visible = is_player_nearby
		$Sprite.play("selected")


func _on_ChestArea_body_exited(body):
	$UI/Info.visible = false
	if body.is_in_group("player") and chest_state == CHEST_STATE.WAIT_FOR_ANSWER:
		is_player_nearby = false
		$UI/Task.visible = is_player_nearby
		$Sprite.play("idle")
		chest_state = CHEST_STATE.CLOSED
