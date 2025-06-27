extends CharacterBody3D

const SPEED = 10.0              # Constant forward speed
const TURN_SPEED = 2.0         # How fast the player rotates (adjust as needed)

func _physics_process(delta):
	# Rotate left/right using input
	var turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	var drift_input = Input.get_action_strength( "ui_accept")
	rotation.y += turn_input * (TURN_SPEED + 0.3*drift_input) * delta

	# Constant forward movement in local z-axis
	var forward_direction = -transform.basis.z.normalized()
	
	var drift_direction = drift_input * turn_input * transform.basis.x.normalized()
	velocity = (drift_direction + forward_direction).normalized() * SPEED
	
	
		

	move_and_slide()
