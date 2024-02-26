extends CharacterBody2D

var gravity: int = 700
var push_up_velocity: int = -400
var is_dead: bool = false

var rnd: RandomNumberGenerator = RandomNumberGenerator.new();

@onready var animation_tree: AnimationTree = $AnimationTree;

@onready var paralax_background = get_node("../ParallaxBackground");

var AUDIO_BUS_NAME = "Player_Sounds"

var sound_twy_1: AudioStream = preload ("res://assets/audio/jaja-twy/1.wav")
var sound_twy_2: AudioStream = preload ("res://assets/audio/jaja-twy/2.wav")
var sound_twy_3: AudioStream = preload ("res://assets/audio/jaja-twy/3.wav")
var sound_twy_4: AudioStream = preload ("res://assets/audio/jaja-twy/4.wav")
var sound_twy_5: AudioStream = preload ("res://assets/audio/jaja-twy/5.wav")
var sounds_twy = [sound_twy_1, sound_twy_2, sound_twy_3, sound_twy_4, sound_twy_5]

var sound_death_1: AudioStream = preload ("res://assets/audio/72208__strangely_gnarled__arrow_woosh__twang_01.wav")

var sound_falling_1: AudioStream = preload ("res://assets/audio/wind/1.wav")
var sound_falling_2: AudioStream = preload ("res://assets/audio/wind/2.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paralax_background.scrollingSpeed = 1000;
	animation_tree.active = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		pass

func _physics_process(delta: float) -> void:
	if (is_dead):
		animation_tree["parameters/conditions/is_dead"] = true
		animation_tree["parameters/conditions/pushing_up"] = false
		animation_tree["parameters/conditions/is_diving"] = false
		animation_tree["parameters/conditions/is_not_diving"] = false
		return

	velocity.y += gravity * delta

	if Input.is_action_just_pressed("fly_up"):
		if velocity.y > 0:
			velocity.y = 0
		velocity.y += push_up_velocity
		animation_tree["parameters/conditions/pushing_up"] = true
		animation_tree["parameters/conditions/is_diving"] = false
		animation_tree["parameters/conditions/is_not_diving"] = false
		var i = rnd.randi_range(0, sounds_twy.size() - 1);
		var sound = sounds_twy[i]
		SfxHandler.play_sfx(sound, 1.0, 1.0, false, AUDIO_BUS_NAME)
	else:
		animation_tree["parameters/conditions/pushing_up"] = false
		if (velocity.y > 10):
			animation_tree["parameters/conditions/is_diving"] = true
			animation_tree["parameters/conditions/is_not_diving"] = false
		else:
			animation_tree["parameters/conditions/is_diving"] = false
			animation_tree["parameters/conditions/is_not_diving"] = true

	if (velocity.y > 0):
		rotation = move_toward(rotation, 50, delta)
	else:
		rotation = move_toward(rotation, 0, delta * 10)

	move_and_slide();

func kill():
	paralax_background.scrollingSpeed = 0;
	is_dead = true;
	await SfxHandler.play_sfx(sound_death_1, 1.0, 1.0, false, AUDIO_BUS_NAME)
	get_tree().change_scene_to_file("res://scenes/main.tscn");
