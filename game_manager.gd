extends Node2D

var count = 0
var numberOfGrass

@onready var score_label: Label = $"../../ScoreLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(numberOfGrass)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score_label.text = str(count) + " / " + str(numberOfGrass / 2)

func progress() -> void: 
	count += 1
	if count >= numberOfGrass / 2:
		get_tree().change_scene_to_file("res://scenes/credits/scrollable_credits.tscn")

func set_number_of_grass(n: int) -> void:
	numberOfGrass = n
