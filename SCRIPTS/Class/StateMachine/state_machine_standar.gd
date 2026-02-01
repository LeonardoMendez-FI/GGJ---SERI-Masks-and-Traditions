class_name StateMachine
extends Node

@export var default_state: StateBase
var controlled_node: Node
var current_state: StateBase = null
var debug = true

func start(owner_node: Node) -> void:
	controlled_node = owner_node
	_change_to(default_state.get_path())

func _change_to(state_path: NodePath) -> void:
	if debug:
		prints(
			"[FSM]",
			controlled_node.name,
			"→",
			state_path
		)

	if current_state:
		if debug:
			prints("[FSM]", "exit", current_state.name)
		current_state.end()

	current_state = get_node(state_path)
	current_state.controlled_node = controlled_node
	current_state.state_machine = self

	if debug:
		prints("[FSM]", "enter", current_state.name)

	current_state.start()


func _process(_delta:float) -> void:
	if current_state and current_state.has_method("on_process"):
		current_state.on_process(_delta)

func _physics_process(_delta: float) -> void:
	if current_state and current_state.has_method("on_physics_process"):
		current_state.on_physics_process(_delta)

func _input(_event: InputEvent) -> void:
	if current_state and current_state.has_method("on_input"):
		current_state.on_input(_event)

func _unhandled_input(_event: InputEvent) -> void:
	if current_state and current_state.has_method("_unhandled_input"):
		current_state.on_unhandled_input(_event)

func _unhandled_key_input(_event: InputEvent) -> void:
	if current_state and current_state.has_method("on__unhandled_key_input"):
		current_state.on__unhandled_key_input(_event)
