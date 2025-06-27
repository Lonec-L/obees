extends CharacterBody3D

const SPEED = 5.0              # Constant forward speed
const TURN_SPEED = 2.5         # How fast the player rotates (adjust as needed)

func _physics_process(delta):
	# Rotate left/right using input
	var turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	rotation.y += turn_input * TURN_SPEED * delta

	# Constant forward movement in local z-axis
	var forward_direction = -transform.basis.z.normalized()
	velocity = forward_direction * SPEED

	move_and_slide()
