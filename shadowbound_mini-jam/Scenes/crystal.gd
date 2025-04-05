extends StaticBody3D

@export var always_on: bool = true
@onready var light: OmniLight3D = $OmniLight3D
@export var sequence: Array[bool] = [false, true]
@export var flash_duration: float = 0.4
var sequence_pointer: int = 0
@export var light_energy: float = 5.0
@onready var ray: RayCast3D = $RayCast3D
var is_flashing: bool = false

@export var range: float = 10.0

func _ready() -> void:
	if not always_on:
		switch_off()
		World.tick.connect(step_sequence)

func get_sequence_value(index: int):
	return sequence[index % len(sequence)]

func step_sequence() -> void:
	var this_step: bool = get_sequence_value(sequence_pointer)
	sequence_pointer += 1
	var next_step: bool = get_sequence_value(sequence_pointer)
	if this_step:
		flash()
	elif next_step:
		# telegraph next step
		telegraph()

func set_flashing():
	is_flashing = true

func switch_off():
	is_flashing = false
	light.hide()

func telegraph():
	light.show()
	light.light_energy = light_energy * 0.25
	var tween = get_tree().create_tween()
	light.omni_range = 0
	tween.tween_property(light, "omni_range", range * 0.4, World.heartbeat_interval/2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(light, "omni_range", 0.0, World.heartbeat_interval/2).set_trans(Tween.TRANS_SINE)

func _physics_process(delta: float) -> void:
	if not (is_flashing or always_on):
		return
	var player: CharacterBody3D = $"../Player"
	if not player is Player:
		return
	var player_direction = (player.global_position - self.global_position).normalized()
	var space_state = get_world_3d().direct_space_state
	var origin = self.global_position
	var end = origin + player_direction * range
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	if "collider" not in result:
		return
	if result["collider"] is Player:
		print("We got hit")
		player.handle_hit()
	
func flash():
	light.show()
	var tween = get_tree().create_tween()
	$AudioStreamPlayer3D.play()
	tween.tween_property(light, "omni_range", range, flash_duration).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(set_flashing)
	light.light_energy = light_energy * 1.0

	get_tree().create_timer(flash_duration * 3).timeout.connect(switch_off)
