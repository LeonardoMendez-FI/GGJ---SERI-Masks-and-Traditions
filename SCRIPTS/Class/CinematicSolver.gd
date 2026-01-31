extends CanvasLayer
class_name CinematicSolver

var cinematics:Array[VideoStreamPlayer]
var current_cinematic:VideoStreamPlayer = null
var current_index:int = -1

func _ready() -> void:
	for child in $Cinematics.get_children():
		if child is VideoStreamPlayer:
			var new_cinematic = child as VideoStreamPlayer
			child.stop()
			child.hide()
			child.connect("finished", on_video_finished)
			cinematics.append(new_cinematic)

func play_next() -> void:
	var next_index:int = current_index + 1
	if cinematics.size() <= next_index:
		return

	current_index = next_index
	current_cinematic = cinematics[next_index]
	
	get_tree().paused = true
	await font_int()
	current_cinematic.show()
	font_out()
	current_cinematic.play()
	
func on_video_finished() -> void:
	current_cinematic.stop()
	await font_int()
	current_cinematic.hide()
	font_out()
	get_tree().paused = false

func font_int() -> void:
	var tween = create_tween()
	var duration = 2
	
	tween.tween_property(
		$TextureRect,
		"self_modulate:a",
		1,
		duration
	)
	
	await tween.finished

func font_out() -> void:
	var tween = create_tween()
	var duration = 2
	
	tween.tween_property(
		$TextureRect,
		"self_modulate:a",
		0,
		duration
	)
	
	await tween.finished
	
	
	
