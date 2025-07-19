extends MeshInstance3D

var trail_points: Array[Vector3] = []
var trail_length := 30

func _ready() -> void:
	mesh = mesh.duplicate()

func _process(delta: float) -> void:
	trail_points.append(get_parent().global_position)
	
	if trail_points.size() > trail_length:
		trail_points.remove_at(0)
	
	_update_trail_mesh()

func _update_trail_mesh() -> void:
	mesh.clear_surfaces()
	
	if trail_points.size() < 2:
		return
	
	global_transform = Transform3D.IDENTITY
	
	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	for point in trail_points:
		mesh.surface_add_vertex(point)
	
	mesh.surface_end()
