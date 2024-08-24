extends Node3D

@export var view_camera:Camera3D
@export var gridmap:GridMap

# Raycasting the mouse
var plane:Plane

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	plane = Plane(Vector3.UP, Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Map postion based on mouse
	var world_position = plane.intersects_ray(
		view_camera.project_ray_origin(get_viewport().get_mouse_position()),
		view_camera.project_ray_normal(get_viewport().get_mouse_position()))
		
	var gridmap_position = Vector3(round(world_position.x),0,round(world_position.z))
	
	# update position
	position = lerp(position,gridmap_position,delta * 40)
