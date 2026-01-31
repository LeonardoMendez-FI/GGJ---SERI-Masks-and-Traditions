extends Node
class_name GameManager

@onready var cinematic_solver = $CinematicSolver
@onready var game = $Game

func _ready() -> void:
	cinematic_solver.play_next()
	game.visible = true
