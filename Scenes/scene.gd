extends Node

@onready var current_scene: Node2D = $Playground

func _ready() -> void:
	# 1. Connect the first level normally
	connect_level_signals(current_scene)

# NEW FUNCTION: Handles finding and connecting portals for ANY level
func connect_level_signals(level_node: Node) -> void:
	var portals_container = level_node.find_child("Portals")
	if portals_container:
		for portal in portals_container.get_children():
			# Check if already connected to avoid errors (optional but safe)
			if not portal.scene_changed.is_connected(handle_scene_change):
				print("Connecting portal: ", portal.name)
				portal.scene_changed.connect(handle_scene_change)

func handle_scene_change(current_scene_name: String):
	# ... (Your existing match code) ...
	var next_scene_name = "Test/Playground.tscn" # Simplified for example
	
	var scene_resource = load("res://Scenes/" + next_scene_name)
	if scene_resource:
		var next_scene = scene_resource.instantiate()
		
		add_child(next_scene)
		
		# 2. IMPORTANT: Connect the new scene's portals immediately!
		connect_level_signals(next_scene)
		
		current_scene.queue_free()
		current_scene = next_scene
