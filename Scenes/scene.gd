extends Node

@onready var current_scene: Node2D = $Playground

func _ready() -> void:
	connect_level_signals(current_scene)

func connect_level_signals(level_node: Node) -> void:
	var portals_container = level_node.find_child("Portals")
	if portals_container:
		for portal in portals_container.get_children():
			if not portal.scene_changed.is_connected(handle_scene_change):
				# Caution: Use CONNECT_DEFERRED to prevent the crash
				portal.scene_changed.connect(handle_scene_change, CONNECT_DEFERRED)


func handle_scene_change(current_scene_name: String):
	var next_scene_name : String
	
	match current_scene_name:
		"emptyspace":
			next_scene_name = "Test/EmptySpace"
		"playground":
			next_scene_name = "Test/Playground"
		"lobby":
			next_scene_name = "Lobby"
	
	var scene_resource = load("res://Scenes/" + next_scene_name + ".tscn")
	if scene_resource:
		var next_scene = scene_resource.instantiate()
		add_child(next_scene)
		connect_level_signals(next_scene)
		
		current_scene.queue_free()
		current_scene = next_scene
