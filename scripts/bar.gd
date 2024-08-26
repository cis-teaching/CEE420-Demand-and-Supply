extends Control
class_name BarChart

@onready var back: ProgressBar = $Back
@onready var front: ProgressBar = $Front

var type:String="Buyer"
var max_value:float = 100
var limit:float = 0
var price:float = 0
var size_x:int = 20
var size_y:int = 180

var sb_limit = StyleBoxFlat.new()
var sb_price = StyleBoxFlat.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size.x = size_x
	custom_minimum_size.y = size_y
	back.value = limit
	front.value = price
	back.max_value = max_value
	front.max_value = max_value
	
	if type == "Seller":
		
		front.add_theme_stylebox_override("fill", sb_limit)
		sb_limit.bg_color = Color("0000003c")
		
		back.add_theme_stylebox_override("fill", sb_price)
		sb_price.bg_color = Color("5dae72")
		
		back.value = price
		front.value = limit
	else:
		back.add_theme_stylebox_override("fill", sb_limit)
		sb_limit.bg_color = Color("ea704850")
		
		front.add_theme_stylebox_override("fill", sb_price)
		sb_price.bg_color = Color("ea7048")
	pass # Replace with function body.

func update_price(value:float)->void:
	if type == "Seller":
		back.value = value
	else:
		front.value = value
		
func update_success(value:bool)->void:
	if type == "Seller":
		if value:
			sb_price.bg_color = Color("5dae72")
		else:
			sb_price.bg_color = Color("5dae727d")
	else:
		if value:
			sb_price.bg_color = Color("ea7048")
		else:
			sb_price.bg_color = Color("ea70487d")
