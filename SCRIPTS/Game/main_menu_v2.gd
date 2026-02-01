extends Control

@onready var bonfire_anim : PointLight2D = $PointLight2D
var light = false

func _ready() -> void:
	$JugarButton.grab_focus()

func _physics_process(delta: float) -> void:
	if !light and bonfire_anim.energy <= 14.0:
		bonfire_anim.energy += 0.5
		if  bonfire_anim.energy >= 14.0:
			light = true
	elif light and bonfire_anim.energy >= 1.0:
		bonfire_anim.energy -= 0.5
		if  bonfire_anim.energy <= 1.0:
			light = false
	

func _on_jugar_button_pressed() -> void:
	#Cambiar a escena principal
	$AudioStreamConfirm.play(0.0)
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_ajustes_button_pressed() -> void:
	$AudioStreamConfirm.play(0.0)
	get_tree().change_scene_to_file("res://opciones.tscn")


func _on_jugar_button_focus_entered() -> void:
	$JugarButton/PointLight2D.enabled = true


func _on_jugar_button_focus_exited() -> void:
	$JugarButton/PointLight2D.enabled = false


func _on_ajustes_button_focus_entered() -> void:
	$AjustesButton/PointLight2D.enabled = true


func _on_ajustes_button_focus_exited() -> void:
	$AjustesButton/PointLight2D.enabled = false
