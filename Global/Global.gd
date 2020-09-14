extends Node


enum STAGE { UNDEFINED, RESOURCES, DESIGN, PILOTS, FLIGHT } 
const STAGE_RESOURCES_TASKS = 3
const STAGE_DESIGN_TASKS = 5
var solved_tasks = 0
var tasks_total = 0
var tries = 0
var final_stage_hp = 0  # depends on pilot difficulty

# scene should be reloaded on game over if current scene is resources
var current_stage = STAGE.UNDEFINED


# execute game over every time player finished game
func game_over():
	solved_tasks = 0
	tasks_total = 0
	tries = 0
	final_stage_hp = 0


func reset_current_stage():
	current_stage = STAGE.UNDEFINED

