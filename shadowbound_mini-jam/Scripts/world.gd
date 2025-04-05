extends Node3D

signal tick

@onready var heartbeat_interval: float = 2.0

func _ready() -> void:
	get_tree().create_timer(heartbeat_interval).timeout.connect(heartbeat)
	
func heartbeat():
	# TODO: Play sound
	tick.emit()
	get_tree().create_timer(heartbeat_interval).timeout.connect(heartbeat)

	
