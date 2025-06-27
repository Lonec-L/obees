extends CanvasLayer

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var label: Label = $VBoxContainer/Label

var isActive = false

var currentProgress = 0
var maxProgress = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_minigame()
	print("StunMinigameFuncStarted")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = currentProgress
	currentProgress -= delta * 10
	currentProgress = clamp(currentProgress, 0, maxProgress)
	if isActive && Input.is_action_just_pressed("mash_spacebar"):
		print("Pressed SPACE!")
		currentProgress += 5
		if currentProgress >= maxProgress:
			end_minigame()


func start_minigame():
	isActive = true
	currentProgress = 0
	progress_bar.value = 0
	visible = true

func end_minigame():
	isActive = false
	visible = false
	# Call function in player to enable it's movement
