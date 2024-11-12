extends Area2D

@export var level_name: String

func _on_body_entered(body):
	if body is Player:
		MainScene.call_deferred("load_level", level_name)
