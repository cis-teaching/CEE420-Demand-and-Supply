extends Node3D

# Load Selector Object
@export var selector:Node3D
@export var gridmap:GridMap
@export var container:Node3D
@export var sprites:Node3D

@onready var seller = preload("res://sprites/seller.tscn")
@onready var buyer = preload("res://sprites/buyer.tscn")

# var agents:Array[PackedScene] = []

@onready var agents = [buyer,seller]
#@onready var selector = %Selector

# Index of structure being built
var index:int = 0
var sprite_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	preview()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get grid position
	var gridmap_position = selector.gridmap_position

	# Add and remove Agents 
	action_add(gridmap_position)
	action_remove(gridmap_position)
	
	# Toggle between agents
	action_toggle()
	
	# Print Information
	#print(gridmap.get_cell_item(gridmap_position))
	#print(gridmap.map_to_local(gridmap_position))
	print(gridmap_position)
	print(sprite_dict)

func action_add(gridmap_position:Vector3) -> void:
	if Input.is_action_just_pressed("agent_add"):
		# var previous_tile = gridmap.get_cell_item(gridmap_position)
		# gridmap.set_cell_item(gridmap_position, index, 
		# 	gridmap.get_orthogonal_index_from_basis(selector.basis))
		if gridmap_position in sprite_dict:
			sprite_dict[gridmap_position].queue_free()
			sprite_dict.erase(gridmap_position)
			
		var _agent = agents[index].instantiate()
		
		# Correction term to fix cell offset
		var _correction = gridmap.cell_size/2
		_correction.y = 0
		_agent.global_position = gridmap.map_to_local(gridmap_position) - _correction

		# Add sprite to scene and dict
		sprites.add_child(_agent)
		sprite_dict[gridmap_position] = _agent
		
func action_remove(gridmap_position:Vector3) -> void:
	if Input.is_action_just_pressed("agent_remove"):
		# gridmap.set_cell_item(gridmap_position, -1)
		
		if gridmap_position in sprite_dict:
			sprite_dict[gridmap_position].queue_free()
			sprite_dict.erase(gridmap_position)


func action_toggle() -> void:
	var tile_size = gridmap.mesh_library.get_item_list().size()

	if Input.is_action_just_pressed("agent_next"):
		index = wrap(index + 1, 0, tile_size)
	
	if Input.is_action_just_pressed("agent_previous"):
		index = wrap(index - 1, 0, tile_size)
		
	preview()

func preview() -> void:
	# Clear preview container
	for n in container.get_children():
		container.remove_child(n)
		
	# Create new preveiw
	var _agent = agents[index].instantiate()
	container.add_child(_agent)
