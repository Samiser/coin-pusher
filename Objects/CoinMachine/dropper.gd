extends AnimatableBody3D

@export var frequency := 0.3
@export var amplitude := 90
var axis := Vector3.FORWARD
var time_passed := 0.0

var dragging := false
var drag_start_mouse_x := 0.0
var original_position: Vector3

@onready var camera := get_viewport().get_camera_3d()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var space_state := get_world_3d().direct_space_state
				var from := camera.project_ray_origin(event.position)
				var to := from + camera.project_ray_normal(event.position) * 1000
				
				var query := PhysicsRayQueryParameters3D.create(from, to)
				
				var result := space_state.intersect_ray(query)
				if result and result.collider == self:
					dragging = true
					drag_start_mouse_x = event.position.x
					original_position = global_position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		var delta_x: float = event.position.x - drag_start_mouse_x
		var move_amount: float = delta_x * 0.0035
		global_position = Vector3(original_position.x + move_amount, original_position.y, original_position.z)


#func _physics_process(delta: float) -> void:
	#time_passed += delta
	#var offset := amplitude * sin(time_passed * frequency * TAU)
	#rotation_degrees = axis * offset
	
