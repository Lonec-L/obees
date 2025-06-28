extends CharacterBody3D

const SPEED = 10.0              # Constant forward speed
const TURN_SPEED = 1.0         # How fast the player rotates (adjust as needed)
var drift_strength = 0
var movement_enabled: bool = true
var _last_drift_dir = 0
var has_chainsaw = false
@onready var chainsaw_timer: Timer = $chainsaw_timer
@export var mg_scene: PackedScene

func _ready():
	# Connect timeout signal
	chainsaw_timer.timeout.connect(_on_chainsaw_timer_timeout)
	
	
func get_chainsaw():
	if has_chainsaw:
		if chainsaw_timer.time_left > 0:
			var new_time = chainsaw_timer.time_left + 20
			chainsaw_timer.stop()
			chainsaw_timer.wait_time = new_time
			chainsaw_timer.start()
			return
	print("get chainsaw")
	has_chainsaw = true
	$body/tree_mower.visible = true
	chainsaw_timer.start(20)

func _on_chainsaw_timer_timeout():
	has_chainsaw = false
	$body/tree_mower.visible = false
	print("Chainsaw expired!")
	
func _physics_process(delta):
	
	if !movement_enabled:
		return
	# Rotate left/right using input
	var turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	if _last_drift_dir != turn_input:
		drift_strength = 0
	_last_drift_dir = turn_input
	var drift_input = Input.get_action_strength( "drift")
	rotation.y += turn_input * (TURN_SPEED + 0.4*drift_input) * delta
	
	if drift_input == 0:
		drift_strength = 0
	elif drift_strength < 1:
		drift_strength = min(drift_strength + 0.5 * delta, 1)
	# Constant forward movement in local z-axis
	var forward_direction = -transform.basis.z.normalized()
	
	var drift_direction = drift_input * turn_input * transform.basis.x.normalized()
	velocity = (4*drift_direction*drift_strength + forward_direction).normalized() * SPEED
	
	velocity -= transform.basis.y.normalized()*3
		
	move_and_slide()
	if has_chainsaw:
		return
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("gTrees") && movement_enabled:
			var ui = mg_scene.instantiate()
			add_child(ui)
			ui.start_stun_minigame()
			movement_enabled = false

func extend_arm(pos: Vector3):
	var slap_dir = pos-global_position
	
	var local_right = global_transform.basis.x

	var dot = slap_dir.normalized().dot(local_right)
	
	if dot > 0:
		$AnimationPlayer.play("slap right")
	elif dot < 0:
		$AnimationPlayer.play("slap left")
	


func _on_area_3d_body_entered(body):
	print(has_chainsaw)
	if has_chainsaw == false:
		return
	if body.is_in_group("gTrees"):
		print("tree")
		body.fall()
