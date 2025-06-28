extends CanvasLayer

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var label: Label = $VBoxContainer/Label

var isActive = false

var currentProgress = 0
var maxProgress = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = currentProgress
	currentProgress -= delta * 10
	currentProgress = clamp(currentProgress, 0, maxProgress)
	if isActive && Input.is_action_just_pressed("mash_spacebar"):
		print("Pressed SPACE!")
		currentProgress += 50
		if currentProgress >= maxProgress:
			end_minigame()


func start_stun_minigame():
	isActive = true
	currentProgress = 0
	progress_bar.value = 0
	visible = true

func end_minigame():
	isActive = false
	visible = false
	var player = get_parent().get_node("player")
	player.movement_enabled = true
	var forward = -player.transform.basis.z.normalized()
	player.global_transform.origin += forward * 3
	# Call function in player to enable it's movement
