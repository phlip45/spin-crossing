@tool
extends Node

var musics:Dictionary[String, AudioStreamMP3] = {}
var sounds:Dictionary[String, AudioStreamMP3] = {}
@export var music_files:Array[String] = []
@export var sfx_files:Array[String] = []

@export_tool_button("Scan Now") var scan_button:Callable = _scan_all

const SFX_ID_FILE:String = "res://sounds/sfx_ids.json"
const MUSIC_ID_FILE:String = "res://sounds/music_ids.json"

var master_volume:float = .5
var music_volume:float = .5
var sfx_volume:float = .5

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var sfx_player_2: AudioStreamPlayer = $SFXPlayer2
@onready var sfx_player_3: AudioStreamPlayer = $SFXPlayer3
@onready var sfx_player_4: AudioStreamPlayer = $SFXPlayer4
@onready var sfx_player_5: AudioStreamPlayer = $SFXPlayer5
@onready var sfx_player_6: AudioStreamPlayer = $SFXPlayer6

var sfx_players:Array[AudioStreamPlayer] = []

enum BUS_TYPE {
	NULL,
	SFX,
	MUSIC
}

func _scan_all() -> void:
	music_files = _scan_folder("res://sounds/music")
	sfx_files = _scan_folder("res://sounds/sfx")
	_generate_audio_enum("res://sounds/sfx_list.gd","SFXList",
						"SFX",sfx_files,SFX_ID_FILE)

	_generate_audio_enum("res://sounds/music_list.gd","MusicList",
						"MUSIC",music_files,MUSIC_ID_FILE)

func _generate_audio_enum(output_path:String,class_name_text:String,
	enum_name_text:String,files:Array[String],id_file:String) -> void:

	var ids:Dictionary = _get_or_create_audio_ids(files,id_file)
	var file:FileAccess = FileAccess.open(output_path,FileAccess.WRITE)
	if file == null:
		push_error("Failed to create %s" % output_path)
		return

	file.store_line("# Auto-generated. Do not edit.")
	file.store_line("class_name %s" %class_name_text)
	file.store_line("extends RefCounted")
	file.store_line("")

	file.store_line("enum %s {" %enum_name_text)

	for path:String in files:
		var audio_name:String = path.get_file().get_basename()

		file.store_line(
			"\t%s = %d," % [make_enum_name(audio_name),int(ids[path])] 
		)

	file.store_line("}")
	file.store_line("")

	file.store_line("const NAMES:Dictionary[%s, String] = {"  % enum_name_text)

	for path:String in files:
		var audio_name:String = path.get_file().get_basename()

		file.store_line('\t%s.%s: "%s",' %
			[enum_name_text, make_enum_name(audio_name), audio_name]
		)
	file.store_line("}")
	file.close()
	
func _load_audio_ids(id_file:String) -> Dictionary:
	if !FileAccess.file_exists(id_file):
		return {}

	var file:FileAccess = FileAccess.open(id_file,FileAccess.READ)

	if file == null:
		return {}

	var json:JSON = JSON.new()

	if json.parse(file.get_as_text()) != OK:
		push_error("Failed to parse %s" % id_file)
		return {}

	return json.data
	
func _save_audio_ids(id_file:String,ids:Dictionary) -> void:
	var file:FileAccess = FileAccess.open(id_file,FileAccess.WRITE)

	if file == null:
		push_error("Failed to write %s" % id_file)
		return

	file.store_string(JSON.stringify(ids, "\t"))
	file.close()

func _get_or_create_audio_ids(files:Array[String],id_file:String) -> Dictionary:
	var ids:Dictionary = _load_audio_ids(id_file)
	var next_id:int = 1
	for value:Variant in ids.values():
		next_id = max(next_id,int(value) + 1)
	for path:String in files:
		if !ids.has(path):
			ids[path] = next_id
			next_id += 1
	_save_audio_ids(id_file, ids)
	return ids
	
func make_enum_name(_name:String) -> String:
	var result:String = _name.to_upper()

	for character:String in [" ", "-", ".", ",", "(", ")", "[", "]"]:
		result = result.replace(character, "_")

	return result

func _scan_folder(path:String) -> Array[String]:
	var results:Array[String] = []

	var dir:DirAccess = DirAccess.open(path)
	if dir == null:
		push_error("busted path: %s" % path)
		return results

	dir.list_dir_begin()
	var file_name:String = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.to_lower().ends_with(".mp3"):
			results.append("%s/%s" % [path, file_name])
		file_name = dir.get_next()

	dir.list_dir_end()
	return results

func _ready() -> void:
	if Engine.is_editor_hint(): return
	_load_audio_list(music_files, musics)
	_load_audio_list(sfx_files, sounds)

	sfx_players = [
		sfx_player,
		sfx_player_2,
		sfx_player_3,
		sfx_player_4,
		sfx_player_5,
		sfx_player_6
	]
	
	load_audio_settings.call_deferred.call_deferred()

func load_audio_settings():
	var bus_index:int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(bus_index,master_volume)
	bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(bus_index,music_volume)
	bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_linear(bus_index,sfx_volume)

func _load_audio_list(paths:Array[String], target:Dictionary[String, AudioStreamMP3]) -> void:
	for path:String in paths:
		var stream:AudioStreamMP3 = load(path) as AudioStreamMP3
		if stream != null:
			var key:String = path.get_file().get_basename()
			target[key] = stream

func play_music(music:MusicList.MUSIC, loop:bool = true) -> void:
	var song:String = MusicList.NAMES.get(music, "")
	if song == "":
		printerr("Music enum not found: ", music)
		return
	if !musics.has(song):
		printerr("Music Doesn't Exist: ", song)
		return
	if music_player.stream == musics[song] and music_player.playing:
		return
	music_player.stream = musics[song]
	music_player.stream.loop = loop
	music_player.play()

func stop_music() -> void:
	music_player.stop()

func get_current_music_volume_db() -> float:
	var bus_index:int = AudioServer.get_bus_index("MUSIC")
	return AudioServer.get_bus_volume_db(bus_index)

func set_music_volume_db(amount:float) -> void:
	var bus_index:int = AudioServer.get_bus_index("MUSIC")
	AudioServer.set_bus_volume_linear(bus_index, amount)

func fade_music(start_volume_db:float, end_volume_db:float, delta:float) -> void:
	var bus_index:int = AudioServer.get_bus_index("MUSIC")
	AudioServer.set_bus_volume_db(bus_index, start_volume_db)
	
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_method(func(progress:float) -> void:
		AudioServer.set_bus_volume_db(
			bus_index,
			lerpf(start_volume_db, end_volume_db, progress)
		),
		0.0, 1.0, delta
	)

func play_sfx(sfx:SFXList.SFX) -> void:
	var sfx_name:String = SFXList.NAMES.get(sfx)
	if !sounds.has(sfx_name):
		printerr("SFX Don't Exist: ", sfx_name)
		return
	
	var chosen:AudioStreamPlayer = null
	for player:AudioStreamPlayer in sfx_players:
		if !player.playing:
			chosen = player
			break
	
	if chosen == null:
		return
	
	chosen.stream = sounds[sfx_name]
	chosen.pitch_scale = randf_range(0.85, 1.1)
	chosen.play()

func is_sfx_playing() -> bool:
	for player:AudioStreamPlayer in sfx_players:
		if player.playing:
			return true
	return false
