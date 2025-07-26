extends RigidBody3D
class_name Dice

func _get_dice_rotation(number: int) -> Vector3:
	var rotations := [
		Vector3(-90, 0, 0),
		Vector3(0, -90, 0),
		Vector3(0, 0, 0),
		Vector3(0, 180, 0),
		Vector3(0, 90, 0),
		Vector3(90, 0, 0),
	]
	var spin := func() -> int: return 360 * (1 + randi() % 3)
	var spin_vector := Vector3(spin.call(), spin.call(), spin.call())
	return rotations[number - 1] + spin_vector

func _animate(number: int, display_position: Vector3) -> void:
	set_freeze_enabled(true)
	var tween := create_tween()
	tween.tween_property(self, "global_position", display_position, 1.0)
	tween.parallel().tween_property(self, "rotation_degrees", _get_dice_rotation(number), 1.0)
	await tween.finished
	return

func get_number_and_animate(camera: Camera3D) -> int:
	var number := randi_range(1, 6)
	await _animate(number, camera.global_position + Vector3(0, 0, -0.3))
	return number
