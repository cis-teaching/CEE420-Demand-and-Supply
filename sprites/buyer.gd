extends AgentClass

class_name BuyerClass



func add() -> void:
	Globals.buyers += 1
	super()
	

func remove() -> void:
	Globals.buyers -= 1
	super()
