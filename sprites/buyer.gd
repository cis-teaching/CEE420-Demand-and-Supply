extends AgentClass

class_name BuyerClass


func _ready() -> void:
	type =  "Buyer"

func adjust_price()->void:
	var adjustment = get_adjustment()
	if success:
		_prices.append(get_price()-adjustment)
	else:
		_prices.append(min(get_price()+adjustment,limit))
	success = false
	
func add() -> void:
	Globals.buyers += 1

func remove() -> void:
	Globals.buyers -= 1
	super()
