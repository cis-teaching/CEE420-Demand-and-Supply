extends AgentClass

class_name SellerClass

func _ready() -> void:
	kind =  "Seller"

func adjust_price()->void:
	var adjustment = get_adjustment()
	if success:
		_prices.append(get_price()+adjustment)
	else:
		_prices.append(max(get_price()-adjustment,limit))
	success = false

func add() -> void:
	Globals.sellers += 1
	super()

func remove() -> void:
	Globals.sellers -= 1
	super()
