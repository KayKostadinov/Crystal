extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL = Vector2.UP

export var _velocity := Vector2.ZERO
export var gravity := 800.0
export var speed := Vector2(200.0, 500.0)

export var health := 20
export var attack_damage := 3
