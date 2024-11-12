extends Node2D

@onready var main_2d = get_tree().get_first_node_in_group("MAIN2D")
@onready var current_scene = main_2d.get_child(0)

func unload_level():
	if is_instance_valid(current_scene):
		main_2d.remove_child(current_scene)
	current_scene = null

func load_level(level_name: String):
	unload_level()
	var level_path := "res://Scenes/%s.tscn" % level_name
	var level_resource := load(level_path)
	if level_resource:
		current_scene = level_resource.instantiate()
		main_2d.add_child(current_scene)
