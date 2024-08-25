extends AgentClass

class_name SellerClass



func add() -> void:
	Globals.sellers += 1
	super()
	

func remove() -> void:
	Globals.sellers -= 1
	super()
