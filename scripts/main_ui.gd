extends CanvasLayer

signal run_trading

@onready var buyer_label: Label = $Status/VBoxContainer/ContainerBuyer/CounterBuyer
@onready var seller_label: Label = $Status/VBoxContainer/ContainerSeller/CounterSeller
@onready var price_label: Label = $Status/VBoxContainer/ContainerPrice/CounterPrice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("status_change", update_status_text)
	update_status_text()

func update_status_text() -> void:
	update_buyer()
	update_seller()
	update_price()

func update_buyer() -> void:
	buyer_label.text = str(Globals.buyers)
	
func update_seller() -> void:
	seller_label.text = str(Globals.sellers)

func update_price() -> void:
	price_label.text = str(Globals.price)

func _on_button_run_pressed() -> void:
	emit_signal("run_trading")
