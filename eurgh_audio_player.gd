extends AudioStreamPlayer

var eugh1 = load("res://Assets/Audio/SFX/EUGH1.mp3")
var eugh2 = load("res://Assets/Audio/SFX/EUGH2.mp3")
var eugh3 = load("res://Assets/Audio/SFX/EUGH3.mp3")
var eugh4 = load("res://Assets/Audio/SFX/EUGH4.mp3")
var grunt1 = load("res://Assets/Audio/SFX/GruntSFX1.mp3")
var grunt2 = load("res://Assets/Audio/SFX/GruntSFX2.mp3")
var grunt3 = load("res://Assets/Audio/SFX/GruntSFX3.mp3")
var scared1 = load("res://Assets/Audio/SFX/Scared1.mp3")
var scared2 = load("res://Assets/Audio/SFX/Scared2.mp3")
var scared3 = load("res://Assets/Audio/SFX/Scared3.mp3")
var scared4 = load("res://Assets/Audio/SFX/Scared4.mp3")
var scared5 = load("res://Assets/Audio/SFX/Scared5.mp3")
var scared6 = load("res://Assets/Audio/SFX/Scared6.mp3")
var crash1 = load("res://Assets/Audio/SFX/CrashSFX.mp3")

@onready var grunt_player: AudioStreamPlayer = $"."
var gruntSFX

func _ready() -> void:
	randomize()
# Called when the node enters the scene tree for the first time.

func eugh():
	var eughs = [eugh1, eugh2, eugh3, eugh4]
	var randomIndex = randi() % eughs.size()
	grunt_player.stream = eughs[randomIndex]
	grunt_player.play()

func grunt():
	var grunts = [grunt1, grunt2, grunt3]
	var randomIndex = randi() % grunts.size()
	grunt_player.stream = grunts[randomIndex]
	grunt_player.play()

func scared():
	var scares = [scared1, scared2, scared3, scared4, scared5, scared6]
	var randomIndex = randi() % scares.size()
	grunt_player.stream = scares[randomIndex]
	grunt_player.play()

func crash():
	grunt_player.stream = crash1
	grunt_player.play()
