extends StaticBody2D

@onready var interaction_area = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	DialogueManager.start_dialog("res://Text/DialogueJSON/testNPC.json")
