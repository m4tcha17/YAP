extends Area2D

@export var status : Healing

func _ready() -> void:
	connect("body_entered", use)
	

# Heal player
func use(body: Node) -> void:
	if body.is_in_group("player"):
		body.status.health += status.healing_factor
		queue_free()
