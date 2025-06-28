extends CharacterBody3D

const SPEED = 10.0              # Constant forward speed
const TURN_SPEED = 1.0         # How fast the player rotates (adjust as needed)
var drift_strength = 0
var movement_enabled: bool = true
var _last_drift_dir = 0
var has_chainsaw = false
var has_nos = false

@onready var chainsaw_timer: Timer = $chainsaw_timer
@onready var nos_timer: Timer = $nos_timer
@onready var colision_timer: Timer = $colision_timer
@export var mg_scene: PackedScene
@onready var you_gonna_die_label: Label = $"../YouGonnaDieLabel"
@onready var you_died_label: Label = $"../YouDiedLabel"

var isAlive = true

@onready var gruntingSFXPlayer: AudioStreamPlayer
@onready var beeSwattingSFXPlayer: AudioStreamPlayer

func _ready():
	# Connect timeout signal
	isAlive = true
	chainsaw_timer.timeout.connect(_on_chainsaw_timer_timeout)
	gruntingSFXPlayer = get_tree().get_current_scene().get_node("EUGH&Grunt&scaredPlayer2")
	beeSwattingSFXPlayer = get_tree().get_current_scene().get_node("BeeSwatingSFXPlayer2")
	nos_timer.timeout.connect(_on_nos_timer_timeout)
	colision_timer.timeout.connect(_on_colision_timer_timeout)
	
func get_epipen():
	$DeathTimer.stop()
	you_gonna_die_label.visible = false
	isAlive = true

func get_nos():
	if has_nos:
		if nos_timer.time_left > 0:
			var new_time = nos_timer.time_left + 20
			nos_timer.stop()
			nos_timer.wait_time = new_time
			nos_timer.start()
			return
	print("get nos")
	has_nos = true
	nos_timer.start(20)

func _on_nos_timer_timeout():
	has_nos = false
	print("Nos expired!")

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
	
	if has_nos:
		velocity *= 1.5
		
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
		beeSwattingSFXPlayer.bee_swat()
	elif dot < 0:
		$AnimationPlayer.play("slap left")
		beeSwattingSFXPlayer.bee_swat()
	


func _on_area_3d_body_entered(body):
	if has_chainsaw == false:
		return
	if body.is_in_group("gTrees"):
		print("tree")
		body.fall()

func _on_area_3d_body_entered_for_bees(body: Node3D) -> void:
	if body.is_in_group("Bees") && isAlive:
		isAlive = false
		you_gonna_die_label.visible = true
		for i in range(10):
			$Timer.start(2)
		$DeathTimer.start(20) # start death proces
		print("You gonna DIEEEEE!")
	if body.is_in_group("Bees"):
		gruntingSFXPlayer.scared()
		
func end_game():
	print("set colision")
	set_collision_layer_value(2, false)
	set_collision_mask_value(2, false)
	colision_timer.start(1)

func _on_colision_timer_timeout():
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)


func _on_death_timer_timeout() -> void:
	# gruntingSFXPlayer.scared()
	you_gonna_die_label.visible = false
	you_died_label.visible = true
	print("YOU DEEEEED")
	Engine.time_scale = 0.0


func _on_timer_timeout_moaning() -> void:
	if !isAlive:
		gruntingSFXPlayer.scared()
