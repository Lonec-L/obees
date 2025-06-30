extends AudioStreamPlayer

var beeSwat1 = load("res://assets/Audio/SFX/FlySwatSFX1.mp3")
var beeSwat2 = load("res://assets/Audio/SFX/FlySwatSFX2.mp3")

@onready var bee_swat_player: AudioStreamPlayer = $"."

func _ready() -> void:
	randomize()

func bee_swat():
	var buzzSounds = [beeSwat1, beeSwat2]
	var randomIndex = randi() % buzzSounds.size()
	bee_swat_player.stream = buzzSounds[randomIndex]
	bee_swat_player.play()
