extends "res://src/actor/actor.gd"


func _ready():
	_velocity.x = -speed.x


func _on_headCollider_body_entered(body):
	if body.global_position.y > $headCollider.global_position.y :
		return
	$CollisionShape2D.disabled = true
	queue_free() #delete node

func _physics_process(delta):
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y


