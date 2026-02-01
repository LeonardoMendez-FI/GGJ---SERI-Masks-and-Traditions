extends Control

func _ready() -> void:
	$InicioButton.grab_focus()

func _on_inicio_button_pressed() -> void:
	$AudioStreamBack.play(0.0)
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_inicio_button_focus_entered() -> void:
	$InicioButton/PointLight2D.enabled = true


func _on_inicio_button_focus_exited() -> void:
	$InicioButton/PointLight2D.enabled = false
