extends CharacterBody2D

@export var status : BASE

var steering_factor := 10.0

func _ready() -> void:
	if not status:
		status = BASE.new()


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var desired_velocity := status.max_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * steering_factor * delta
	position += velocity * delta
	
	move_and_slide()
