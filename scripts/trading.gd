extends Node

@onready var sprites = $"../Sprites"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# print(sprites.get_child_count())
	pass

func negotiation(buyer:BuyerClass,seller:SellerClass) -> bool:
	var success:bool=false
	var transaction:float
	
	if buyer.get_initial() == INF:
		buyer.set_initial(buyer.limit)

	if seller.get_initial() == INF:
		seller.set_initial(seller.limit)
		
	var bid:float = buyer.get_price()
	var ask:float = seller.get_price()
	
	if ask <= bid:
		transaction = ask
		success = true
		
	if success:
		buyer.set_price(transaction)
		seller.set_price(transaction)

	return success


func _on_main_ui_run_trading() -> void:
	print('run simulation')
	var buyer:BuyerClass
	var seller:SellerClass
	var success:bool=false
	for n in sprites.get_children():
		if n.type == "Buyer":
			buyer = n
		else:
			seller = n

	if not buyer or not seller:
		return
	success = negotiation(buyer,seller)
	print(success)
