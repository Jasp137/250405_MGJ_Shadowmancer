class_name Player extends CharacterBody3D

@export var post_hit_invincibility_duration = 3.0
@export var speed : float = 5.0
@export var rotation_speed : float = 5.0
@export var starting_hitpoints: int = 3
var hitpoints = 3
var invincible: bool = false
var starting_position: Vector3

var target_rotation : float = 0.0

func _ready() -> void:
	_update_hp_label()
	starting_position = position

func reset():
	hitpoints = starting_hitpoints
	position = starting_position
	_update_hp_label()
	$GameOver.hide()
	$Mesh.show()
	
func _input(event: InputEvent) -> void:
	if event.is_action("restart"):
		reset()

func _update_hp_label():
	$Hitpoints.text = "HP: " + str(hitpoints)
	
func remove_invincibility():
	self.invincible = false

func handle_hit():
	if invincible:
		return
	hitpoints -= 1
	hitpoints = max(0, hitpoints) # clamo to 0
	_update_hp_label()
	# add invincibility cooldown
	invincible = true
	get_tree().create_timer(post_hit_invincibility_duration).timeout.connect(remove_invincibility)
	
	if hitpoints <= 0:
		$GameOver.show()
		$Mesh.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get input from the WASD keys
	if hitpoints <= 0:
		return
	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("character_right"): # D key or right arrow
		input_dir.x += 1
	if Input.is_action_pressed("character_left"): # A key or left arrow
		input_dir.x -= 1
	if Input.is_action_pressed("character_up"): # W key or up arrow
		input_dir.z -= 1
	if Input.is_action_pressed("character_down"): # S key or down arrow
		input_dir.z += 1
	
	# Normalize direction to prevent faster diagonal movement
	input_dir = input_dir.normalized()

	# Move the character in the isometric direction (X and Z are the main axes in the top-down view)
	velocity.x = input_dir.x * speed
	velocity.z = input_dir.z * speed
	# Rotate vector with character
	velocity = velocity.rotated(Vector3.UP, self.rotation.y)

	# Apply the movement using move_and_slide
	move_and_slide()
