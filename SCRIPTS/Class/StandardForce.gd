extends AnimatableBody3D
class_name StandardForce

signal finished_trap
var terrain:Terrain3D

func _create(parent:ForcesManager, current_item:ItemClass) -> void:
	var player = parent.player
	print("CREANDO TRAMPA")
	visible = false
	parent.add_child(self)
	
	await move_to_init(get_init_pos(current_item, player), player)
	
	visible = true
	terrain = parent.terrain
	
	await _appears()
	await _turn_on()
	finished_trap.emit()
	await _disappears()
	queue_free()
	
func _appears() -> void:
	var init_pos:Vector3 = get_terrain_pos(global_position)
	var tween = create_tween()
	
	tween.tween_property(
		self,
		"global_position",
		init_pos,
		3
	)
	
	await tween.finished
	
func _turn_on() -> void:
	await get_tree().create_timer(10).timeout

func _disappears() -> void:
	
	var final_pos = global_position
	final_pos.y -= 50
	
	var tween = create_tween()
	
	tween.tween_property(
		self,
		"global_position",
		final_pos,
		3
	)
	
	await tween.finished

func get_terrain_pos(
	pos: Vector3,
	cast_up: bool = false,
	distance: float = 2000.0,
	offset: float = 0.2
) -> Vector3:
	
	var result_pos = pos
	
	var direction = Vector3.UP if cast_up else Vector3.DOWN
	var hit_point = terrain.get_intersection(pos, direction * distance)

	if hit_point.y < 3.4e38:
		result_pos.y = hit_point.y + offset

	return result_pos

func get_init_pos(current_item: ItemClass, _player:Player) -> Vector3:
	var init_pos: Vector3 = current_item.global_transform.origin
	init_pos.y -= 50
	
	return init_pos

func move_to_init(current_pos: Vector3, player: Player) -> void:
	var tween = create_tween()

	# 1. Mover al destino
	tween.tween_property(
		self,
		"global_position",
		current_pos,
		0.2
	)

	# 2. Calcular rotación hacia el jugador
	var dir = player.global_position - global_position
	var target_y = atan2(dir.x, dir.z)

	# 3. Rotar hacia el jugador después de llegar
	tween.tween_property(
		self,
		"rotation:y",
		target_y,
		0.2
	)

	await tween.finished
	
