class_name AgentClass
extends Node3D



# Class varialbes
@export var limit:float=10
var _initial:float=INF
var _prices:Array[float]=[_initial]
var success:bool=false
var type:String="Agent"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_price()->float:
	return _prices[-1]
	
func set_price(price:float)->void:
	_prices.append(price)
	success=true
	
func get_initial()->float:
	return _initial
	
func set_initial(price:float)->void:
	_initial = price
	_prices.append(price)
	
func adjust_price()->void:
	pass
	
func get_adjustment(kind:String="fixed")->float:
	var adjustment:float = 1
	
	if kind == "random":
		var random = RandomNumberGenerator.new()
		random.randomize()
		if random.randf() < 0.5:
			adjustment = 0
			
	elif kind == "function":
		adjustment = (0.2 * abs(self.get_price()-limit) +1) ** 0.5
		
	return adjustment

func add() -> void:
	#_prices.append(limit)
	#adjust_price()
	pass

func remove() -> void:
	queue_free()
