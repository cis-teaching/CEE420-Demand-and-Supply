extends Node

@onready var sprites = $"../Sprites"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# print(sprites.get_child_count())
	pass

func negotiation(buyer:BuyerClass,seller:SellerClass) -> bool:
	var success:bool=false
	return success


func _on_main_ui_run_trading() -> void:
	print('run simulation')
	for n in sprites.get_children():
		print(n.kind)
