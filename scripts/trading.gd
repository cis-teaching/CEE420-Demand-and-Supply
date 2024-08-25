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
		buyer.set_initial(seller.limit)

	if seller.get_initial() == INF:
		seller.set_initial(buyer.limit)
	
	var bid:float = buyer.get_price()
	var ask:float = seller.get_price()
	
	if ask <= bid:
		transaction = ask
		success = true
		
	if success:
		buyer.set_price(transaction)
		seller.set_price(transaction)

	return success

func market() -> void:
	print('run simulation')
	# Initalize local variables
	var buyers:Array[BuyerClass]
	var sellers:Array[SellerClass]
	var success:bool=false
	var counter:int=0
	var delay:float = 0.1
	var waiting:Array = []
	var prices:Array[float] = []
	# Collect Objects
	for agent in sprites.get_children():
		if agent.type == "Buyer":
			buyers.append(agent)
		else:
			sellers.append(agent)
			
	for i in range(10):
		print("Iteration ",i)
		
		waiting.clear()
		
		buyers.shuffle()
		sellers.shuffle()

		for buyer in buyers:
			for seller in sellers:
				if buyer in waiting or seller in waiting:
					continue
				success = negotiation(buyer,seller)
				if success:
					prices.append(buyer.get_price())
					waiting.append(buyer)
					waiting.append(seller)
					
		for buyer in buyers:
			buyer.adjust_price()
		
		for seller in sellers:
			seller.adjust_price()

		print(prices)
		await get_tree().create_timer(delay).timeout
#
	#if not buyer or not seller:
		#return
	#success = negotiation(buyer,seller)
	#print(success)

func _on_main_ui_run_trading() -> void:
	market()
