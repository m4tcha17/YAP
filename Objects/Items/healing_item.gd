extends Area2D

@export var status : Healing

func _ready() -> void:
	connect("body_entered", use)
	

# Heal player
func use(body: Node) -> void:
	body.status.health -= status.healing_factor
	body.status.health = clampi(body.status.health, 0, 100)
	if body.is_in_group("player"):
		queue_free()
