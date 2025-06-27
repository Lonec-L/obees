extends Node3D

var player = null
var speed = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if player:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		global_translate(direction * speed * delta)
		look_at(player.global_transform.origin + direction, Vector3.UP)
		rotate_y(deg_to_rad(90))


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Attacked the B")
		queue_free()  # "Smack" — remove the bee
