extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var meditation_sounds = {
	0.5: "meditation_begin",
	-7.5: "meditation_begin"
}
var _playing_keys = []
var _playing_audio_streams = []
var _sound_path = "res://audio_prefabs/%1.tscn"

@onready var _main_scene = get_node(_scene_paths.MAIN_SCENE)

@export var duration_mins = 2.5 # In minutes
@export var possible_durations = [2.5]
var time_elapsed = 0.0
var playing = false


func _process(delta):
	if playing:
		time_elapsed += delta

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
	time_elapsed = 0.0
	update_children()
	for node in _playing_audio_streams:
		node.queue_free()
	_playing_keys = []
	_playing_audio_streams = []
