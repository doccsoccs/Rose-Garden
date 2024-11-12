extends Node2D

@onready var player = get_tree().get_first_node_in_group("PLAYER")

var active_areas = []
var can_interact = true

func register_area(area: InteractionArea):
	active_areas.push_back(area)

func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func get_interaction():
	if active_areas.size() > 0:
		can_interact = false
		active_areas.sort_custom(sort_by_distance)
		active_areas[0].interact.call()

func sort_by_distance(a, b):
	return a.get_parent().position.distance_to(player.position) < b.get_parent().position.distance_to(player.position)
