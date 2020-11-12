extends KinematicBody2D
class_name Actor

export var velocity := Vector2.ZERO
export var gravity := 3000.0
export var speed := Vector2(300.0, 1000.0)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
