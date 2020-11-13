extends Actor


var can_jump: bool

func _physics_process(delta):
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	_velocity = get_move_velocity(_velocity, speed, direction, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)


func get_direction() -> Vector2:
	if is_on_floor():
		can_jump = true
	
	if !is_on_floor():
		coyote_time()
	
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		-1.0 if Input.get_action_strength("jump") and can_jump else 1.0
		)


func get_move_velocity(linear_velocity: Vector2, speed: Vector2, direction: Vector2, is_jump_interrupted: bool) -> Vector2:
	var ms := linear_velocity
	ms.x = speed.x * direction.x
	ms.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		ms.y = speed.y * direction.y 
	
	if is_jump_interrupted:
		ms.y = 0
	
	return ms


func coyote_time():
	yield(get_tree().create_timer(.1), "timeout")
	can_jump = false
