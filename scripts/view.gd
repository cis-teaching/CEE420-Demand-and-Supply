extends Node3D

# Initalize vectors to store camera position and rotation
var camera_position:Vector3
var camera_rotation:Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Inital rotation
	camera_rotation = rotation_degrees


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Set position and rotation targest
	
	position = position.lerp(camera_position, delta * 8)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	# Function to handle keyboard inputs
	handle_input(delta)
	
func handle_input(_delta:float) -> void:
	
	# Movement
	
	var input_move := Vector3.ZERO
	
	input_move.x = Input.get_axis("camera_left","camera_right")
	input_move.z = Input.get_axis("camera_forward","camera_back")
	
	input_move = input_move.rotated(Vector3.UP,rotation.y).normalized()
	
	# Update position
	camera_position += input_move / 4
	
	# Rotation
	
	var input_rotation := Vector3.ZERO
	
	input_rotation.y = Input.get_axis("camera_rotate_left","camera_rotate_right")
	
	# Update rotation
	camera_rotation += input_rotation
	
	# Center camera
	
	if Input.is_action_pressed("camera_center"):
		camera_position=Vector3()
