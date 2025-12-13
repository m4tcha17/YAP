extends CharacterBody2D


var skibidi = 10

func _physics_process(delta: float) -> void:
	position += Vector2(100, 0)
