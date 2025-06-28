extends Node3D

var player = null
@export var speed = 10
@export var target_offset_range: float = 5.0
@export var turn_speed: float = 2.5

@export var base_height: float = randf_range(1.5,2.5)
var bob_amplitude: float = 0.5
var bob_speed: float = 5
var bob_offset: float = 0.0

var target_offset: Vector3
# Called when the node enters the scene tree for the first time.

@onready var bee_sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D

var beeSwatSounds = [
	load("res://Assets/Audio/SFX/BzzSFX1.mp3"),
	load("res://Assets/Audio/SFX/BzzSFX2.mp3"),
	load("res://Assets/Audio/SFX/BzzSFX3.mp3")
]

func _ready() -> void:	
	randomize()
	bee_sfx.stream = beeSwatSounds[randi() % beeSwatSounds.size()]
	bee_sfx.play()
	player = get_parent().get_node("player")
	bob_offset = randf() * PI * 2
	
	global_position.y = base_height
	
	target_offset = Vector3(
		randf_range(-target_offset_range, target_offset_range),
		randf_range(0.5 * -target_offset_range, 0.5 * target_offset_range),
		randf_range(-target_offset_range, target_offset_range)
	)
	
	$AnimationPlayer.play("flap_flap")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if player:

		# Bobbing on Y axis using time from OS.get_ticks_msec()
		var time_sec = Time.get_ticks_msec() / 1000.0
		var bob_y = base_height + sin(time_sec * bob_speed + bob_offset) * bob_amplitude

		# Set final position with bobbing
		var pos = global_transform.origin
		pos.y = bob_y
		global_transform.origin = pos

		# Look at player horizontally
		var look_target = player.global_transform.origin
		look_target.y = global_transform.origin.y  # Keep horizontal look only
		var current_forward = -global_transform.basis.z.normalized()
		var desired_direction = (look_target - global_transform.origin).normalized()

		var new_direction = current_forward.lerp(desired_direction, clamp(turn_speed * delta, 0.0, 1.0)).normalized()
		look_at(global_transform.origin + new_direction, Vector3.UP)
		# Optional: rotate_y if needed to fix model facing direction
		#rotate_y(deg_to_rad(90))
		global_translate(new_direction * speed * delta)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if global_transform.origin.distance_to(player.global_transform.origin) <= 20:
			print("Attacked the B")
			var player = get_node("../player")
			player.extend_arm(global_transform.origin)
			queue_free()
