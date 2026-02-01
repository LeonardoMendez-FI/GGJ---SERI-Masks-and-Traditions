extends Node3D
class_name GameClass

@onready var player: Player = $Player
@onready var terrain:Terrain3D
@onready var forces_manager: ForcesManager = $ForcesManager
@onready var energy_bar: ProgressBar = $UI_Game/%EnergyBar
@onready var stages_count: ProgressBar = $UI_Game/%StagesCount
var player_last_position:Vector3
var respawning:bool = false

var energy_drain: float = 30

func _ready() -> void:
	terrain = $Enviroment.get_node("DesertTerrain")
	var item_solver:ItemsSolver = $ItemsSolver
	
	forces_manager.items = item_solver.item_pool
	forces_manager.player = player
	forces_manager.terrain = terrain
	
	player_last_position = player.global_transform.origin
	player.empty_energy.connect(_on_player_energy_empty)
	item_solver.start(self)

func _process(delta: float) -> void:
	player.energy = max(0, player.energy - energy_drain * delta)
	energy_bar.value = player.energy

func _taked_item(item: ItemClass) -> void:
	
	player_last_position = player.global_transform.origin
	player.energy = 600
	
	var audio: AudioStreamPlayer = $AudioStreamPlayer
	
	# Fade OUT audio
	var tween_out = create_tween()
	tween_out.tween_property(audio, "volume_db", -80, 2)
	await tween_out.finished
	
	# Cambio de etapa
	var parent = get_parent()
	if parent is GameManager:
		var game_manager := parent as GameManager
		await game_manager._change_stage()
	
	# Fade IN audio
	var tween_in = create_tween()
	tween_in.tween_property(audio, "volume_db", 0.0, 2)

	# Limpiar items inválidos
	var solver = $ItemsSolver
	solver.item_pool = solver.item_pool.filter(
		func(i): return is_instance_valid(i)
	)

	if is_instance_valid(item):
		solver.item_pool.erase(item)

	stages_count.value = min(
		stages_count.max_value,
		stages_count.value + 1
	)
	
	if stages_count.value < stages_count.max_value:
		forces_manager.change_stage()
	else:
		print("JUEGO TERMINADO")
		get_tree().change_scene_to_file(GameScenes.main_menu_scene)

func _on_player_energy_empty() -> void:
	if respawning:
		return
	respawning = true
	player.set_physics_process(false)
	
	var audio: AudioStreamPlayer = $AudioStreamPlayer

	# Fade OUT
	var tween_out = create_tween()
	tween_out.tween_property(audio, "volume_db", -80, 2)
	await tween_out.finished

	# Cambio de etapa
	var parent = get_parent()
	if parent is GameManager:
		var game_manager := parent as GameManager
		await game_manager._change_stage(true)

	# Respawn jugador
	player.velocity = Vector3.ZERO
	player.global_position = player_last_position
	player.energy = 600

	# Fade IN
	var tween_in = create_tween()
	tween_in.tween_property(audio, "volume_db", 0.0, 2)
	await tween_in.finished

	respawning = false
	player.set_physics_process(true)
