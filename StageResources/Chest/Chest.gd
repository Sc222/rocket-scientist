extends Node2D

signal send_answer(is_correct)

const CORRECT_ANSWER = "Правильный ответ!"
const WRONG_ANSWER = "Вы ошиблись!"
enum CHEST_STATE { OPENED, CLOSED, WAIT_FOR_ANSWER, EXPLODED } 

var is_player_nearby = false
var chest_state = CHEST_STATE.CLOSED
var correct_answer = ""
var answer_variants = []


func _process(_delta):
	if is_player_nearby and chest_state == CHEST_STATE.WAIT_FOR_ANSWER:
		print("Checking")
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
		$UI/Task.visible = is_player_nearby
		$UI/Info.visible = false
		$Sprite.play("selected")
		chest_state = CHEST_STATE.WAIT_FOR_ANSWER


func _on_ChestArea_body_exited(body):
	if body.is_in_group("player"):
		is_player_nearby = false
		$UI/Info.visible = false
		$UI/Task.visible = false
		if chest_state == CHEST_STATE.WAIT_FOR_ANSWER:
			chest_state = CHEST_STATE.CLOSED
		if chest_state == CHEST_STATE.CLOSED:
			$Sprite.play("idle")
