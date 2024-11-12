extends StaticBody2D

@onready var interaction_area = $InteractionArea
@export var file_address: String

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	DialogueManager.start_dialog(file_address)
