extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var meditation_sounds = {
	0.5: "meditation_begin",
	-7.5: "meditation_begin"
}
var _meditation_sounds = {}
var _playing_keys = []
var _playing_audio_streams = []
var _sound_path = "res://audio_prefabs/%1.tscn"

var _main_scene
var _settings_menu
var _user_data

@export var duration_mins = 0.5 # In minutes
var interval_mins = 0.0
var secondary_interval_mins = 0.0
@export var possible_durations = [2.5]
@export var possible_intervals = []
@export var possible_secondary_intervals = []

var next_interval = 0.0
var next_secondary_interval = 0.0
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

		for key in _meditation_sounds.keys():
			if key in _playing_keys:
				continue

			var duration_in_secs = duration_mins * 60.0
			if (key >= 0.0 and key < time_elapsed) or \
				(key < 0.0 and time_elapsed > duration_in_secs + key):
				var audio_stream = _main_scene.create_node(_sound_path.replace("%1", _meditation_sounds[key]), self)
				_playing_keys.append(key)
				_playing_audio_streams.append(audio_stream)
				audio_stream.playing = true

func update_children():
	for child in get_children():
		if child is AudioStreamPlayer2D:
			child.stream_paused = not playing

func play():
	playing = true

	if time_elapsed == 0.0:
		# Meditation just began
		_meditation_sounds = {}
		for key in meditation_sounds.keys():
			_meditation_sounds[key] = meditation_sounds[key]

		if interval_mins > 0.0:
			var ticker_mins = interval_mins
			while(ticker_mins <= duration_mins):
				_meditation_sounds[ticker_mins * 60.0] = "meditation_begin"
				if secondary_interval_mins > 0.0:
					_meditation_sounds[(ticker_mins + secondary_interval_mins) * 60.0] = "meditation_begin"
				ticker_mins += interval_mins

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

	next_interval = 0.0
	next_secondary_interval = 0.0
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

	
