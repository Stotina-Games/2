extends Node
class_name SFXPlayerClass

var background_music_stream_player: AudioStreamPlayer
var background_music_1: AudioStream = preload ("res://assets/audio/forest-lullaby-110624 - Music by Oleksii Kaplunskyi from Pixabay.mp3")
var background_music_2: AudioStream = preload ("res://assets/audio/hiding-place-in-the-forest-111724 - Music by Geoff Harvey from Pixabay.mp3")

func _ready() -> void:
	background_music_stream_player = AudioStreamPlayer.new()
	background_music_stream_player.bus = "Background_Music"
	play_sfx_on_stream_player(background_music_stream_player, background_music_1, 1.0, 1.0, false, self)

func play_sfx(
	sound: AudioStream,
	pitch_range: float=1.0,
	volume_db: float=1.0,
	wait_for_stream_player_to_be_free: bool=false,
	bus: StringName="Master",
	parent: Node=get_tree().current_scene
	):
	var stream_player = AudioStreamPlayer.new()
	stream_player.bus = bus
	await play_sfx_on_stream_player(stream_player, sound, pitch_range, volume_db, wait_for_stream_player_to_be_free, parent)
	stream_player.queue_free()

func play_sfx_on_stream_player(
	stream_player: AudioStreamPlayer,
	sound: AudioStream,
	pitch_range: float=1.0,
	volume_db: float=1.0,
	wait_for_stream_player_to_be_free: bool=false,
	parent: Node=get_tree().current_scene):
	if stream_player == null:
		return
	if sound == null:
		return
	if parent == null:
		return

	if stream_player.playing and wait_for_stream_player_to_be_free:
		await stream_player.finished;

	stream_player.stream = sound
	stream_player.pitch_scale = pitch_range
	stream_player.volume_db = volume_db

	parent.add_child(stream_player)
	stream_player.play()

	await stream_player.finished
