extends CanvasLayer

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var label: Label = $VBoxContainer/Label
@onready var lawn_mowing_player: AudioStreamPlayer

var isActive = false

var currentProgress = 0
var maxProgress = 100

func _ready():
	lawn_mowing_player = get_tree().get_current_scene().get_node("LawnMowingPlayer2")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_parent()
	player.rotation.y += delta
	progress_bar.value = currentProgress
	currentProgress -= delta * 10
	currentProgress = clamp(currentProgress, 0, maxProgress)
	if isActive && Input.is_action_just_pressed("mash_spacebar"):
		print("Pressed SPACE!")
		currentProgress += 15
		if currentProgress >= maxProgress:
			end_minigame()


func start_stun_minigame():
	isActive = true
	currentProgress = 0
	progress_bar.value = 0
	visible = true
	lawn_mowing_player.should_resume_mid_after_end = false
	lawn_mowing_player.stop_mower()

func end_minigame():
	isActive = false
	visible = false
	var player = get_parent()
	player.movement_enabled = true
	var forward = -player.transform.basis.z.normalized()
	player.global_transform.origin += forward
	lawn_mowing_player.should_resume_mid_after_end = true
	lawn_mowing_player.mower_boot_up
	player.end_game()
	queue_free()
	# Call function in player to enable it's movement
