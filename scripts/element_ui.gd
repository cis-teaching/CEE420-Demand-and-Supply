extends CanvasLayer
@onready var selector: Node3D = $"../Selector"
@onready var panel: Panel = $Control/Panel
@onready var builder: Node3D = $"../Builder"
@onready var slider: HSlider = $Control/Panel/VBoxContainer/SliderLimit
@onready var label: Label = $Control/Panel/VBoxContainer/LabelLimit

var active:bool =false
var agent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("agent_edit"):
		if builder.gridmap_position in builder.sprite_dict:
			agent = builder.sprite_dict[builder.gridmap_position]
			slider.value = agent.limit
			panel.position = get_viewport().get_mouse_position()
			if not active:
				show()
				active = true
		else:
			hide()
			active = false
	# 			update_view()

func update_view()->void:
	if active:
		hide()
		active = false
	else:
		show()
		active = true



func _on_slider_limit_value_changed(value: float) -> void:
	label.text = str(value)
	agent.limit = value
	
