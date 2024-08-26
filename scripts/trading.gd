extends Node

@onready var sprites = $"../Sprites"
@onready var bar = preload("res://interfaces/bar.tscn")
@onready var container = %BarContainer
@onready var chart_ui: CanvasLayer = $"../ChartUI"

func _ready() -> void:
	chart_ui.hide()

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
	var delay:float = 0.1
	var waiting:Array = []
	var prices:Array[float] = []
	var averages:Array[float] = []
	var limits:Array = []
	# Collect Objects
	for agent in sprites.get_children():
		limits.append(agent.limit)
		if agent.type == "Buyer":
			buyers.append(agent)
		else:
			sellers.append(agent)
	
	var bin_size = int(300/float(sprites.get_child_count())-4)
	var bar_height = int(min(limits.max()+10,100))
	
	
	buyers.sort_custom(sort_descending)
	sellers.sort_custom(sort_ascending)
	
	chart_ui.show()
	visualization_clean()
	visualization_add(buyers,bar_height,bin_size)
	visualization_add(sellers,bar_height,bin_size)
	
	for i in range(100):
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
			buyer.bar.update_price(buyer.get_price())
			buyer.bar.update_success(buyer.success)
			buyer.adjust_price()
			
		
		for seller in sellers:
			seller.bar.update_price(seller.get_price())
			seller.bar.update_success(seller.success)
			seller.adjust_price()
			
		if prices:
			averages.append(sum_array(prices)/prices.size())
		prices.clear()

		if averages:
			Globals.price = averages[-1]
		if averages.size() > 5 and averages[-1]>0:
			if averages.slice(-5).all(func(element): return element == averages[-1]):
				break

		await get_tree().create_timer(delay).timeout

	for agent in sprites.get_children():
		agent.set_initial(INF)

func sort_ascending(a, b):
	if a.limit < b.limit:
		return true
	return false
	
func sort_descending(a, b):
	if a.limit > b.limit:
		return true
	return false
	
func sum_array(array):
	var sum = 0.0
	for element in array:
		sum += element
	return sum
	
func visualization_add(agents:Array,max_value:float=50,bin_size:int=40) -> void:
			
	for agent in agents:
		var _bar:BarChart = bar.instantiate()
		_bar.max_value = max_value
		_bar.type = agent.type
		_bar.size_x = bin_size
		_bar.limit = agent.limit
		container.add_child(_bar)
		agent.bar = _bar

func visualization_clean() -> void:
	for n in container.get_children():
		container.remove_child(n)
		
func _on_main_ui_run_trading() -> void:
	market()
	#visualize()
	pass
