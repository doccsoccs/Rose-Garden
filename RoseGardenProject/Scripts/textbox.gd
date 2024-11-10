extends CanvasLayer

var active: bool = false

var filename: String
var file
var json_as_text
var json_as_dict

var dialogue
var reading: bool = false
var line_index: int = -1

const char_read_time = 0.03
var char_read_timer = 0
var char_array = []
var count = 0

var display_text : String = ""
@onready var examine_text = $Textbox/Control/InteractText
@onready var character_text = $Textbox/Control/CharacterText
@onready var name_label = $Textbox/Control/NameLabel

# ENUM: text VS text with labeled speaker
enum TextType {EXAMINE, NPC}
var current_text_type: TextType

func _process(delta):
	if reading:
		# Wait for next character
		char_read_timer += delta
		
		# Show next character
		if count < char_array.size():
			if char_read_timer >= char_read_time:
				char_read_timer = 0
				display_text += char_array[count]
				count += 1
				
				# EXAMINE
				if current_text_type == TextType.EXAMINE:
					examine_text.text = display_text
				# NPC
				elif current_text_type == TextType.NPC:
					character_text.text = display_text
		
		# ELSE --> finished displaying/reading line
		else:
			reading = false
			char_read_timer = 0

func _input(event):
	if event.is_action_pressed("Interact") and active:
		if !reading:
			next_line()
		else:
			finish_reading()

func init_dialogue():
	active = true
	get_tree().paused = true
	$".".visible = true
	
	# Read in text from JSON file
	file = "res://Text/DialogueJSON/{0}.json".format({0:filename})
	json_as_text = FileAccess.get_file_as_string(file)
	json_as_dict = JSON.parse_string(json_as_text)
	dialogue = json_as_dict # contains an array of individual lines
	
	# Get TEXTTYPE enum from first line
	line_index = 0
	current_text_type = TextType.get(dialogue[line_index]['type'])
	
	next_line()

func next_line():
	if !reading: # only advance to next line if the line has finished displaying
		clear_all_text()
		line_index += 1 # next line
		
		# End dialogue after last line
		if line_index >= dialogue.size():
			end_dialogue()
			return
		
		# Examine Text
		if current_text_type == TextType.EXAMINE:
			char_array = dialogue[line_index].split()
		
		# NPC Text
		elif current_text_type == TextType.NPC:
			name_label.text = dialogue[line_index]['name']
			char_array = dialogue[line_index]['text'].split()
		
		reading = true
		count = 0

func end_dialogue():
	active = false
	$".".visible = false
	clear_all_text()
	get_tree().paused = false

# Automatically finishes displaying the text in a given line
func finish_reading():
	# EXAMINE
	if current_text_type == TextType.EXAMINE:
		display_text = dialogue[line_index]
		examine_text.text = display_text
	# NPC
	elif current_text_type == TextType.NPC:
		display_text = dialogue[line_index]['text']
		character_text.text = display_text
	
	reading = false
	char_read_timer = 0

# Sets all text boxes to empty strings
func clear_all_text():
	display_text = ""
	examine_text.text = ""
	character_text.text = ""
	name_label.text = ""
