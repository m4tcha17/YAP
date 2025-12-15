extends Area2D

@onready var collision: CollisionShape2D = $collision

signal scene_changed
@export var scene_name: String = "..."

func _ready() -> void:
	connect("body_entered", teleport)


func teleport(node) -> void:
	if node.is_in_group("player"):
		#get_tree().change_scene_to_file("res://Scenes/EmptySpace.tscn")
		print("BANG")
		emit_signal("scene_changed", scene_name)
