extends Area2D

export var horizontal_speed:float
export var vertical_speed:float



func _physics_process(delta):
	position.x += horizontal_speed * delta
	position.y += vertical_speed * delta
