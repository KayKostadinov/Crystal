extends "res://src/actor/actor.gd"


func _ready():
	_velocity.x = -speed.x



func _physics_process(delta):
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y


func _on_DamageCollider_area_entered(area):
	if area.name == 'fireball':
#		health -= area.attack_damage
		print(area.is_in_group('damaging'))
	if health <= 0:
		$CollisionShape2D.disabled = true
		queue_free() #delete node
