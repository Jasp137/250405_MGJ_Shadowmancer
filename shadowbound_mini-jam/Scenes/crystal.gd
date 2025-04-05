extends StaticBody3D

@export var always_on: bool = true
@onready var light: OmniLight3D = $OmniLight3D
@export var sequence: Array[bool] = [false, true]
@export var flash_duration: float = 0.4
var sequence_pointer: int = 0
@export var light_energy: float = 5.0
@onready var ray: RayCast3D = $RayCast3D

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


func switch_off():
	light.hide()

func telegraph():
	light.show()
	light.light_energy = light_energy * 0.25
	var tween = get_tree().create_tween()
	light.omni_range = 0
	tween.tween_property(light, "omni_range", range * 0.4, World.heartbeat_interval/2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(light, "omni_range", 0.0, World.heartbeat_interval/2).set_trans(Tween.TRANS_SINE)

func check_player_hit():
	var player: CharacterBody3D = $"../Player"
	var ray: RayCast3D = $RayCast3D
	ray.target_position =  player.global_position - self.position
	var collider = ray.get_collider()
	print(collider)
	
func flash():
	light.show()
	var tween = get_tree().create_tween()
	tween.tween_property(light, "omni_range", range, flash_duration).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(check_player_hit)
	
	light.light_energy = light_energy * 1.0

	get_tree().create_timer(flash_duration).timeout.connect(switch_off)
