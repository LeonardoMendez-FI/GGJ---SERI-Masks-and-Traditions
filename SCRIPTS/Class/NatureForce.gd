extends Node3D
class_name NatureForce

signal force_finished

func start(player:Player, item:ItemClass, terrain:Terrain3D) -> void:
	get_start_position(player, item, terrain)
	create_force(player, item, terrain)
	await force_finished
	destroy_force()

func get_start_position(_player:Player, _item:ItemClass, _terrain:Terrain3D) -> void:
	pass
	
func create_force(_player:Player, _item:ItemClass, _terrain:Terrain3D) -> void:
	push_warning("create_force not implemented")
	emit_signal("force_finished")

func destroy_force() -> void:
	queue_free()
