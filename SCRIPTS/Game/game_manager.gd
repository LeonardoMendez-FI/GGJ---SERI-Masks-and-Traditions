extends Node
class_name GameManager

@onready var cinematic_solver:CinematicSolver = $CinematicSolver
@onready var game:GameClass = $Game

func _ready() -> void:
	cinematic_solver.play_next()
	game.visible = true

func _change_stage(repeat:bool = false) -> void:
	await cinematic_solver.play_next(repeat)
