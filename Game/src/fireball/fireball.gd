extends RigidBody2D

var force := Vector2(0, 0)
export var force_multiplier = 100
export var attack_damage := 5


func _physics_process(delta):
	#position.x += horizontal_speed * delta
	#position.y += vertical_speed * delta
	var force_to_be_added = force * force_multiplier * delta
	
	set_applied_force(force_to_be_added)
