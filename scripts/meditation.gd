extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var meditation_sounds = {
	0.5: "meditation_begin",
	-7.5: "meditation_begin"
}
var _playing_sounds = []
var _sound_path = "res://audio_prefabs/%1.tscn"

@onready var _main_scene = get_node(_scene_paths.MAIN_SCENE)

@export var duration = 2.0 # In minutes
var time_elapsed = 0.0
var playing = false


func _process(delta):
	if playing:
		time_elapsed += delta

		for key in meditation_sounds.keys():
			if key in _playing_sounds:
				continue

			var duration_in_minutes = duration * 60.0
			if (key >= 0.0 and key < time_elapsed) or \
				(key < 0.0 and time_elapsed > duration_in_minutes + key):
				var audio_stream = _main_scene.create_node(_sound_path.replace("%1", meditation_sounds[key]), self)
				_playing_sounds.append(key)   
				audio_stream.playing = true             

func play():
	playing = true
	update_children()

func pause():
	playing = false
	update_children()

func update_children():
	for child in get_children():
		if child is AudioStreamPlayer2D:
			child.stream_paused = not playing

