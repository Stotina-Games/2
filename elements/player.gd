extends CharacterBody2D

var gravity: int = 700
var push_up_velocity: int = -400
var is_dead: bool = false

@onready var animation_tree: AnimationTree = $AnimationTree;

@onready var paralax_background = get_node("../ParallaxBackground");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paralax_background.scrollingSpeed = 1000;
	animation_tree.active = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	else:
		animation_tree["parameters/conditions/pushing_up"] = false
		if(velocity.y > 10):
			animation_tree["parameters/conditions/is_diving"] = true
			animation_tree["parameters/conditions/is_not_diving"] = false
		else:
			animation_tree["parameters/conditions/is_diving"] = false
			animation_tree["parameters/conditions/is_not_diving"] = true

	if(velocity.y > 0):
		rotation = move_toward(rotation, 50, delta)
	else:
		rotation = move_toward(rotation, 0, delta*10)

	move_and_slide();

func kill():
	paralax_background.scrollingSpeed = 0;
	is_dead = true;

