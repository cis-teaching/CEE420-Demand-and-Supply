extends "res://scripts/agent.gd"

func add() -> void:
	Globals.buyers += 1

func remove() -> void:
	Globals.buyers -= 1
	queue_free()
