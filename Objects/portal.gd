extends Area2D

@onready var cooldown: Timer = %Cooldown
@onready var collision: CollisionShape2D = %collision

# Signal configuration
signal scene_changed(current_scene_name: String, entry_tag: String)
@export var entry_tag: String = "Default_Spawn"

func _ready() -> void:
	# 1. Start with the portal disabled
	collision.disabled = true
	
	# 2. Setup and start the timer explicitly
	cooldown.one_shot = true
	if not cooldown.timeout.is_connected(portal_activate):
		cooldown.timeout.connect(portal_activate)
	
	cooldown.start() # Triggers the countdown immediately
	
	# 3. Listen for player entering
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func portal_activate() -> void:
	# 4. Safely re-enable the collision (prevents physics crashes)
	collision.set_deferred("disabled", false)
	print("Portal is now active!")

func _on_body_entered(body: Node2D) -> void:
	# Check for group AND ensure it's a CharacterBody2D if needed
	if body.is_in_group("player"):
		var current_scene_name = owner.name.to_lower()
		print("Leaving scene: ", current_scene_name)
		scene_changed.emit(current_scene_name, entry_tag)
