extends "res://scripts/agent.gd"

func add() -> void:
	Globals.sellers += 1

func remove() -> void:
	Globals.sellers -= 1
	queue_free()
