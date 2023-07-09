extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var meditation_sounds = {
	0.5: "meditation_begin",
	-7.5: "meditation_begin"
}
var _playing_keys = []
var _playing_audio_streams = []
var _sound_path = "res://audio_prefabs/%1.tscn"

var _main_scene
var _settings_menu
var _user_data

@export var duration_mins = 0.5 # In minutes
@export var possible_durations = [2.5]
var time_elapsed = 0.0
var playing = false


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_settings_menu = get_node(_scene_paths.SETTINGS_MENU)
	_user_data = get_node(_scene_paths.USER_DATA)

func _process(delta):
	if playing:
		time_elapsed += delta

		if time_elapsed / 60.0 > duration_mins:
			stop()

		for key in meditation_sounds.keys():
			if key in _playing_keys:
				continue

			var duration_in_secs = duration_mins * 60.0
			if (key >= 0.0 and key < time_elapsed) or \
				(key < 0.0 and time_elapsed > duration_in_secs + key):
				var audio_stream = _main_scene.create_node(_sound_path.replace("%1", meditation_sounds[key]), self)
				_playing_keys.append(key)
				_playing_audio_streams.append(audio_stream)
				audio_stream.playing = true

func update_children():
	for child in get_children():
		if child is AudioStreamPlayer2D:
			child.stream_paused = not playing

func play():
	playing = true
	update_children()

func pause():
	playing = false
	update_children()

func stop():
	playing = false
	var save_time = false
	var save_time_amount = time_elapsed

	if time_elapsed / 60.0 > duration_mins / 2 or \
		time_elapsed / 60.0 > 1.0:
		save_time = true

	time_elapsed = 0.0
	update_children()
	for node in _playing_audio_streams:
		if not node == null:
			node.queue_free()
	_playing_keys = []
	_playing_audio_streams = []

	if save_time:
		_save_time(save_time_amount / 60.0)

func _save_time(time_mins):
	_user_data.save_meditation("silence", time_mins)

	_settings_menu.activate_save_time_menu(self)

	
