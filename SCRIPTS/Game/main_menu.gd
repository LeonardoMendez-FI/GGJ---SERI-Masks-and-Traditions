extends Control

func _ready() -> void:
	var tween = create_tween()
	var duration = 2
	
	tween.tween_property(
		$CanvasLayer/Control/TextureRect,
		"self_modulate:a",
		0,
		duration
	)
	
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		$CanvasLayer/Control/AudioStreamPlayer2D.play()
		start_game()

func start_game():
	var tween = create_tween()
	var duration = 4
	
	tween.tween_property(
		$CanvasLayer/Control/TextureRect,
		"self_modulate:a",
		1,
		duration
	)

	$CanvasLayer/Control/VideoStreamPlayer.loop = false
	await $CanvasLayer/Control/VideoStreamPlayer.finished
	tween.stop()
	get_tree().change_scene_to_file(GameScenes.game_manager_scene)
