extends Node3D

# Load Selector Object
@export var selector:Node3D
@export var gridmap:GridMap

#@onready var selector = %Selector

# Index of structure being built
var index:int = 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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

func action_add(gridmap_position:Vector3) -> void:
	if Input.is_action_just_pressed("agent_add"):
		# var previous_tile = gridmap.get_cell_item(gridmap_position)
		gridmap.set_cell_item(gridmap_position, index, 
			gridmap.get_orthogonal_index_from_basis(selector.basis))
		
func action_remove(gridmap_position:Vector3) -> void:
	if Input.is_action_just_pressed("agent_remove"):
		gridmap.set_cell_item(gridmap_position, -1)

func action_toggle() -> void:
	var tile_size:int = gridmap.mesh_library.get_item_list().size()
	print(tile_size)
	if Input.is_action_just_pressed("agent_next"):
		index = wrap(index + 1, 0, 2)
	
	if Input.is_action_just_pressed("agent_previous"):
		index = wrap(index - 1, 0, 2)
