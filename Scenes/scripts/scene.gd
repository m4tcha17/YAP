extends Node

signal player_changed(player)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_scene: Node2D = $Lobby
@onready var ui: CanvasLayer = $UI
@onready var player : CharacterBody2D
var next_scene

func _ready() -> void:
	# Find initial player (current scene)
	player = current_scene.find_child("Player")
	connect_level_signals(current_scene)

# UPDATES THE CURRENT SCENE
func connect_level_signals(level_node: Node) -> void:
	var portals_container = level_node.find_child("Portals")
	if portals_container:
		# Listen for scene change requests from all portals in the level
		for portal in portals_container.get_children():
			if not portal.scene_changed.is_connected(handle_scene_change):
				# Connect portals to the manager (Deferred to prevent physics crashes)
				portal.scene_changed.connect(handle_scene_change, CONNECT_DEFERRED)
	

func handle_scene_change(current_scene_name: String, entry_tag: String):
	var next_scene_name: String = ""
	
	print("Leaving: " + current_scene_name + " | Tag: " + entry_tag)

	match current_scene_name:
		# -----------------------------------------------------------
		# CASE 1: WE ARE LEAVING THE LOBBY
		# -----------------------------------------------------------
		"lobby":
			match entry_tag:
				"to_oop":
					next_scene_name = "Rooms/oop"
				"to_dsa":
					next_scene_name = "Rooms/dsa"
				"to_networking":
					next_scene_name = "Rooms/networking"
				_:
					print("Error: Unknown tag in Lobby: " + entry_tag)
					return

		# -----------------------------------------------------------
		# CASE 2: WE ARE LEAVING A SPECIFIC ROOM (Going back to Lobby)
		# -----------------------------------------------------------
		"oop":
			# If we leave OOP, we usually go back to Lobby
			next_scene_name = "Rooms/lobby"
		"dsa":
			next_scene_name = "Rooms/lobby"
			
		"networking":
			next_scene_name = "Rooms/lobby"

		# -----------------------------------------------------------
		# CASE 3: OTHER SCENES
		# -----------------------------------------------------------
		"playground":
			next_scene_name = "Rooms/Lobby"
			
		_:
			print("Error: No match found for scene: " + current_scene_name)
			return
	
	# Load the Scene
	var scene_resource = load("res://Scenes/" + next_scene_name + ".tscn")
	
	if scene_resource:
		next_scene = scene_resource.instantiate()
		add_child(next_scene)
		
		# --- POSITIONING LOGIC ---
		# We look for a Marker2D in the new scene that matches the 'entry_tag'
		var spawn_marker = next_scene.find_child(entry_tag)
		var next_player = next_scene.find_child("Player")
		
		if spawn_marker and next_player:
			if player and is_instance_valid(player):
				next_player.status = player.status
			next_player.global_position = spawn_marker.global_position
			player = next_player
			# EMIT SIGNAL (current player has changed)
			player_changed.emit(player)
		else:
			print("Warning: Missing Marker named '" + entry_tag + "' in " + next_scene_name)
		animation_player.play("fade_in")
	else:
		print("Error: Could not load scene: " + next_scene_name)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"fade_in":
			connect_level_signals(next_scene)
			current_scene.queue_free()
			current_scene = next_scene
			next_scene = null
			animation_player.play("fade_out")
