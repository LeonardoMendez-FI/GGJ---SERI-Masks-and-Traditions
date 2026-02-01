extends Node3D
class_name ForcesManager

@export var stages:Array[Stages_List]
var player:Player
var terrain:Terrain3D
var items:Array[ItemClass] = []
var stage_index:int = -1
var current_stage:GameConstants.STAGES_LEVELS
var machine_running:bool = false

func turn_on_machine(current_player:Player,\
current_items:Array[ItemClass], current_terrain:Terrain3D) -> void:
	
	player = current_player
	items = current_items
	terrain = current_terrain
	
	change_stage()

func change_stage() -> void:
	
	stop_machine()
	await get_tree().process_frame
	
	var next_index = stage_index + 1
	if stages.size() <= next_index:
		return
	
	current_stage = stages[next_index].Stage
	stage_index = next_index
	if player and player.camera_shaker:
		player.camera_shaker.shake(0.3, 2)
		
	start_machine()
	while machine_running:
		var item = get_nearest_item()
		if item == null:
			break
		await create_forces(item)

func get_nearest_item() -> ItemClass:
	
	var nearest_item:ItemClass = null
	if items.any(func(i): return !is_instance_valid(i)):
		items = items.filter(is_instance_valid)

	if items.is_empty():
		return null
	
	var nearest_distance:float = INF
	
	for item in items:
			
		var item_pos:Vector3 = item.global_transform.origin
		var player_pos:Vector3 = player.global_transform.origin
		var aux_distance = item_pos.distance_to(player_pos)
		if  aux_distance < nearest_distance:
			nearest_distance = aux_distance
			nearest_item = item
	
	return nearest_item

func create_forces(item:ItemClass) -> void:
	
	var multiplier = get_multiplier()
	if multiplier == 0:
		await get_tree().create_timer(1).timeout
		return
		
	var forces_escenes = get_forces_scenes(multiplier)
	if forces_escenes.is_empty():
		await get_tree().create_timer(1).timeout
		return
	var last_force:NatureForce
		
	for force in forces_escenes:
		if not machine_running:
			break
		var new_force = force.instantiate() as NatureForce
		if new_force == null:
			continue
		add_child(new_force)
		last_force = new_force
		new_force.start(player, item, terrain)
		await get_tree().create_timer(randf_range(2.0,4.0)).timeout
		if not machine_running:
			break

	if machine_running and last_force and is_instance_valid(last_force):
			await last_force.force_finished

func get_multiplier() -> int:
	var multipliers = stages[stage_index].Multiplicator
	var keys = multipliers.keys()
	keys.sort()
	keys.reverse()

	
	for key in keys:
		var percentage = multipliers[key]
		if randi_range(0,100) <= percentage:
			return key
	
	return 0

func get_forces_scenes(multiplier:int) -> Array[PackedScene]:
	var forces:Array[PackedScene] = []
	var creator = stages[stage_index].Creator
	var forces_list = stages[stage_index].Forces
	
	var keys = creator.keys()
	keys.sort()
	keys.reverse()

	for i in range(multiplier):
		for key in keys:
			if randi_range(0,100) <= creator[key]:
				var chosen:PackedScene = null
				
				match key:
					GameConstants.FORCES_RANGE.Range1:
						chosen = pick_random(forces_list.R1_Forces)
					GameConstants.FORCES_RANGE.Range2:
						chosen = pick_random(forces_list.R2_Forces)
					GameConstants.FORCES_RANGE.Range3:
						chosen = pick_random(forces_list.R3_Forces)
					GameConstants.FORCES_RANGE.Range4:
						chosen = pick_random(forces_list.R4_Forces)
				
				if chosen:
					forces.append(chosen)
				break

	return forces

func pick_random(arr:Array):
	if arr.is_empty():
		return null
	return arr.pick_random()
	
func stop_machine() -> void:
	machine_running = false

func start_machine() -> void:
	machine_running = true
