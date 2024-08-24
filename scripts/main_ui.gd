extends CanvasLayer

@onready var buyer_label: Label = $Control/VBoxContainer/ContainerBuyer/CounterBuyer
@onready var seller_label: Label = $Control/VBoxContainer/ContainerSeller/CounterSeller

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("status_change", update_status_text)
	update_status_text()

func update_status_text() -> void:
	update_buyer()
	update_seller()

func update_buyer() -> void:
	buyer_label.text = str(Globals.buyers)
	
func update_seller() -> void:
	seller_label.text = str(Globals.sellers)
