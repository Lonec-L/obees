extends AudioStreamPlayer

var beeSwat1 = load("res://Assets/Audio/SFX/FlySwatSFX1.mp3")
var beeSwat2 = load("res://Assets/Audio/SFX/FlySwatSFX2.mp3")

@onready var bee_swat_player: AudioStreamPlayer = $"."
var gruntSFX

func _ready() -> void:
	randomize()
# Called when the node enters the scene tree for the first time.

func bee_swat():
	var eughs = [beeSwat1, beeSwat2]
	var randomIndex = randi() % eughs.size()
	bee_swat_player.stream = eughs[randomIndex]
	bee_swat_player.play()
