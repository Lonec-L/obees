extends Node3D

var player = null
@export var speed = 5
@export var target_offset_range: float = 5.0

var base_height: float
var bob_amplitude: float = 0.5
var bob_speed: float = 5
var bob_offset: float = 0.0

var target_offset: Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("player")
	base_height = global_transform.origin.y
	bob_offset = randf() * PI * 2
	
	target_offset = Vector3(
		randf_range(-target_offset_range, target_offset_range),
		randf_range(0.5 * -target_offset_range, 0.5 * target_offset_range),
		randf_range(-target_offset_range, target_offset_range)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if player:
		# Move horizontally towards player
		var direction = (player.global_transform.origin - global_transform.origin)
		direction.y = 0  # Ignore vertical for horizontal movement
		direction = direction.normalized()
		global_translate(direction * speed * delta)

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
		look_at(look_target, Vector3.UP)

		# Optional: rotate_y if needed to fix model facing direction
		rotate_y(deg_to_rad(90))


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and global_transform.origin.distance_to(player.global_transform.origin) <= 20:
		print("Attacked the B")
		queue_free()  # "Smack" — remove the bee
