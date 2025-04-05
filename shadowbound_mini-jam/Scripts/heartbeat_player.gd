extends AudioStreamPlayer

func _ready() -> void:
	World.tick.connect(play_heartbeat)

func play_heartbeat():
	
	self.play()
	print("Playing it")
