extends Node3D
class_name CameraShaker

var shake_time := 0.0
var strength := 0.0
var original_pos := Vector3.ZERO

func _ready():
	original_pos = position

func _process(delta):
	if shake_time > 0:
		shake_time -= delta
		
		var offset = Vector3(
			randf_range(-1, 1),
			randf_range(-1, 1),
			0
		) * strength
		
		position = original_pos + offset
	else:
		position = original_pos

func shake(power: float, duration: float):
	strength = power
	shake_time = duration
