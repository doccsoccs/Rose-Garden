extends Node

const hour_time: float = 0.5
var current_hour: int = 0
const meridiem: Array[String] = ["AM", "PM"]

var day: int = 1
var clock_time: float
var clock_string: String

@onready var time_manager = get_tree().get_first_node_in_group("TIMEMNGR")
@onready var time_label = get_tree().get_first_node_in_group("TIMELABEL")

enum CycleEnum {MORNING, AFTERNOON, EVENING, NIGHT}
var cycle_state: CycleEnum

# Initialize the first instance of the hour timer
func _ready():
	time_manager.wait_time = hour_time

# Game time is from 6AM to 2AM --> 6,7,8,9,10,11 / 12,1,2,3,4,5 / 6,7,8,9,10,11 / 12,1,2
#										0-5				6-11			12-17		18-20
func _process(_delta):
	# Timer pauses while in dialog or interacting
	if !DialogueManager.in_dialog:
		time_manager.paused = false
		update_time()
	else:
		time_manager.paused = true

# Moves from the current time of day to the next
# Days are structured: MORNING --> AFTERNOON --> EVENING --> NIGHT
func next_hour():
	reset_timer()
	match current_hour:
		0,1,2,3,4,5:
			cycle_state = CycleEnum.MORNING
			pass
		6,7,8,9,10,11:
			cycle_state = CycleEnum.AFTERNOON
			pass
		12,13,14,15,16,17:
			cycle_state = CycleEnum.EVENING
			pass
		18,19,20:
			cycle_state = CycleEnum.NIGHT
			pass
		_:
			next_day()

# Resets the timer and begins the next countdown
func reset_timer():
	current_hour += 1
	time_manager.start(hour_time)

# Initializes the next day of the game
func next_day():
	day += 1
	current_hour = 0

# Runs every frame, updates time display
func update_time():
	var current_meridiem: String
	if current_hour <= 5 || current_hour >= 18:
		current_meridiem = meridiem[0]
	else:
		current_meridiem = meridiem[1]
	
	clock_string = "%s %s" % [(current_hour + 5)%12 + 1, current_meridiem]
	time_label.text = "DAY %s - %s\n%s" % [day, CycleEnum.keys()[cycle_state], clock_string]
	#str(snapped(clock_time, 0.1)), CycleEnum.keys()[cycle_state]

func _on_timeout():
	next_hour()
