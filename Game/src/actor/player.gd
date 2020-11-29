extends Actor

var fireball = preload("res://src/fireball/fireball.tscn")

var can_jump: bool
var jump_pressed: bool
var can_shoot := true

export var d_jump_speed := 1000
var just_d_jumped := false

func _physics_process(delta):
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	_velocity = get_move_velocity(_velocity, speed, direction, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	
	flip_sprite()
	idle_anim()
	run_anim()
	jump_anim()
	shoot()
	can_double_jump()


# return movement direction
func get_direction() -> Vector2:
	
	# coyote time
	can_jump = false
	if is_on_floor():
		can_jump = true
	if !is_on_floor() && Input.is_action_just_released("jump"):
		coyote_time()
	
	# remember jump before touching the ground
	jump_pressed = false
	if Input.is_action_just_pressed("jump"):
		jump_pressed = true
		jump_extention()
	
	# return 
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		-1.0 if Input.is_action_pressed("jump") and (can_jump and jump_pressed) else 1.0
		)


# return movement velocity
func get_move_velocity(linear_velocity: Vector2, speed: Vector2, direction: Vector2, is_jump_interrupted: bool) -> Vector2:
	var ms := linear_velocity
	ms.x = speed.x * direction.x
	ms.y += gravity * get_physics_process_delta_time()
	
	
	if direction.y == -1.0:
		ms.y = speed.y * direction.y 
	
	if is_jump_interrupted:
		ms.y = 0
	
	if Input.is_action_just_pressed("double_jump") and can_double_jump():
		ms.y = -d_jump_speed
		just_d_jumped = true
	
	return ms


# double jump
func d_jump() -> Vector2:
	
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		-1.0 if can_double_jump() else 1.0
		)

# is double jump possible
func can_double_jump() -> bool:
	if is_on_floor():
		just_d_jumped = false
	
	if !is_on_floor() and !is_on_wall() and !just_d_jumped:
		return true
	return false

# timeout func to implement coyote time  
func coyote_time():
	yield(get_tree().create_timer(.1), "timeout")
	can_jump = false


# remember jump before landing
func jump_extention():
	yield(get_tree().create_timer(.2), "timeout")
	jump_pressed = false


# shooting interval
func shoot_cooldown():
	can_shoot = false
	yield(get_tree().create_timer(.5), "timeout")
	can_shoot = true



# shoot
func shoot():
	if Input.is_action_pressed("shoot") and can_shoot:
		
		var ball = fireball.instance()
		
		ball.position = position
		ball.position.y -= 25
		
		ball.horizontal_speed = 500* -(Input.get_action_strength("move_left") - Input.get_action_strength("move_right"))
		ball.vertical_speed = 500* -(Input.get_action_strength("move_up") - Input.get_action_strength("move_down"))
		
		if ball.vertical_speed == 0 and ball.horizontal_speed == 0:
			return
			
		
		shoot_cooldown()
		
		get_tree().current_scene.add_child(ball)


# Animations -------->

#flip sprite
func flip_sprite():
	if _velocity.x < 0:
		$playerSprite.set_flip_h(true)
	if _velocity.x > 0:
		$playerSprite.set_flip_h(false)

# idle
func idle_anim():
	if _velocity == Vector2.ZERO:
		$playerSprite.play("idle")
	# play idle animation

# run
func run_anim():
	#play run animation
	if _velocity.x != 0:
		$playerSprite.play("run")
	

# jump
func jump_anim():
	if _velocity.y < 0:
		if _velocity.x == 0:
			$playerSprite.play("jump")
		else:
			$playerSprite.play("jump_side")
	elif !is_on_floor():
		if _velocity.x == 0:
			$playerSprite.play("fall")
		else:
			$playerSprite.play("fall_side")

# Animations <--------
