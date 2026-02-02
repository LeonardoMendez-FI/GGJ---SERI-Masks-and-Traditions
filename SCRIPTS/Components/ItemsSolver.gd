extends Node3D
class_name ItemsSolver

var item_pool: Array[ItemClass] = []
var current_tween: Tween = null

func start(game:GameClass) -> void:
	var items = get_children()
	
	for child in items:
		if child is ItemClass:
			var new_item = child as ItemClass
			item_pool.append(new_item)
			new_item.taked_object.connect(game._taked_item)
	
	# Pequeña pausa para que todo esté listo
	await get_tree().process_frame
	await distribute(game.terrain)


func distribute(terrain:Terrain3D) -> void:
	var count := item_pool.size()
	if count == 0:
		return

	var height := 15
	var rise_duration := 1.5
	var spread_duration := 0.6
	var radius := 200

	var center_position = global_position

	# --- FASE 1: subir al centro ---
	var rise_tween = create_tween()
	rise_tween.set_parallel(true)

	for item in item_pool:
		item.collision.disabled = true

		var elevated_center = center_position + Vector3(0, height, 0)

		rise_tween.tween_property(
			item, "global_position", elevated_center, rise_duration
		)

		rise_tween.tween_property(
			item, "rotation:y",
			item.rotation.y + TAU * 2,
			rise_duration
		)

	await rise_tween.finished


	# --- FASE 2: distribuir ---
	var spread_tween = create_tween()
	spread_tween.set_parallel(true)

	for i in range(count):
		var item = item_pool[i]

		var angle = TAU * i / count
		var direction = Vector3(cos(angle), 0, sin(angle))

		var horizontal_pos = center_position + direction * radius

		# Lanzar rayo desde arriba
		var ray_origin = horizontal_pos + Vector3(0, 1000, 0)
		var hit = terrain.get_intersection(ray_origin, Vector3.DOWN)

		var final_position = horizontal_pos

		# Si golpea terreno
		if hit.y < 3.4e38:
			final_position.y = hit.y + 3  # pequeño offset
		else:
			final_position.y = center_position.y + height

		spread_tween.tween_property(
			item, "global_position", final_position, spread_duration
		)
	
	await spread_tween.finished

	_on_distribution_complete()


func _on_distribution_complete() -> void:
	for item in item_pool:
		if is_instance_valid(item):
			item.collision.set_deferred("disabled", false)
	current_tween = null
