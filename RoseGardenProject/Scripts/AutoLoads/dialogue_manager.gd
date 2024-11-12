extends Node

@onready var textbox = get_tree().get_first_node_in_group("TEXTBOX")
var in_dialog: bool = false

func start_dialog(file_address: String):
	textbox.init_dialog(file_address)
