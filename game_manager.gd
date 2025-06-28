extends Node2D

var count = 0
var numberOfGrass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(numberOfGrass)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func progress() -> void: 
	count += 1

func set_number_of_grass(n: int) -> void:
	numberOfGrass = n
