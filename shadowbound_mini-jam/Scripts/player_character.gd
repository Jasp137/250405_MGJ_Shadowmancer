extends CharacterBody3D

@export var speed : float = 5.0
@export var rotation_speed : float = 5.0

var target_rotation : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get input from the WASD keys
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

	# Apply the movement using move_and_slide
	move_and_slide()
