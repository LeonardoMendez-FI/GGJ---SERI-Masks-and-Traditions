class_name Utils


static func play_clip_stop(player: AudioStreamPlayer3D, clip: AudioStream):
	player.stop()
	player.stream = clip
	player.play()


static func play_clip(player: AudioStreamPlayer3D, clip: AudioStream):
	if !player.playing:
		player.stream = clip
		player.play()


static func play_clip_plain(player: AudioStreamPlayer, clip: AudioStream):
	if !player.playing:
		player.stream = clip
		player.play()


static func formatted_vec3(v: Vector3) -> String:
	return "(%.1f,%.1f,%.1f)" % [
		v.x,v.y,v.z
	]


static func formatted_dt() -> String:
	var dt = Time.get_datetime_dict_from_system()
	var short_str = "%02d/%02d %02d:%02d" % [dt.day, dt.month, dt.hour, dt.minute]
	return short_str


static func print_with_parent(node: Node, text: String) -> void:
	print(node.get_parent().name, " :: ", text)
