extends Control

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		start_game()

func start_game():
	$CanvasLayer/Control/VideoStreamPlayer.paused =  true
	get_tree().change_scene_to_file(GameScenes.game_manager_scene)
