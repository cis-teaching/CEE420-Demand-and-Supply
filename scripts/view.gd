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
	
func handle_input(_delta):
	
	# Movement
	
	var input := Vector3.ZERO
	
	input.x = Input.get_axis("camera_left","camera_right")
	input.z = Input.get_axis("camera_forward","camera_back")
	
	input = input.rotated(Vector3.UP,rotation.y).normalized()
	
	# Update position
	camera_position += input / 4
	
	# Center camera
	
	if Input.is_action_pressed("camera_center"):
		camera_position=Vector3()
	
func _input(event):
	
	# Rotate camera
	
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("camera_rotate"):
			camera_rotation += Vector3(0, -event.relative.x / 10, 0)
		
