extends Node

const STAGE_RESOURCES_TASKS = 3
const STAGE_DESIGN_TASKS = 5
var solved_tasks = 0
var tasks_total = 0
var tries = 0

# execute game over every time player finished game
func game_over():
	solved_tasks = 0
	tasks_total = 0
	tries = 0
