extends Actor


func _physics_process(delta):
	velocity = speed * get_direction()
	velocity = move_and_slide(velocity)


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		-1.0 if Input.get_action_strength("jump") and is_on_floor() else 1.0
		)


func get_move_velocity() -> 
