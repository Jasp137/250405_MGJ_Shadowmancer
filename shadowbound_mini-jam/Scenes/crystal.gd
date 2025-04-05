extends StaticBody3D

@export var always_on: bool = true
@onready var light: OmniLight3D = $OmniLight3D
@export var flash_duration: float = 0.2
@export var flash_interval: float = 3.0

@export var range: float = 10.0 :
	get:
		return light.omni_range
	set(value):
		$OmniLight3D.omni_range = value
		notify_property_list_changed()

func _ready() -> void:
	if not always_on:
		switch_off()

func switch_off():
	light.hide()
	get_tree().create_timer(flash_interval).timeout.connect(flash_on)

func flash_on():
	light.show()
	#TODO: Ray cast to player
	get_tree().create_timer(flash_duration).timeout.connect(switch_off)
