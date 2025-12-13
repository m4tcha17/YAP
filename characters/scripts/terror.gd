extends CharacterBody2D

@onready var field: Area2D = $Field
@export var status: BASE

# We will store the variables directly here to avoid "status" confusion
var current_target: Node2D = null
var pointer: RayCast2D = null

func _ready() -> void:
	if not status:
		status = BASE.new()
	status.max_speed = 501
	# 1. Create the Raycast ONCE when the game starts
	pointer = RayCast2D.new()
	add_child(pointer)
	pointer.enabled = true # Important!
	
	# 2. Connect signals
	field.body_entered.connect(get_object_reference)
	field.body_exited.connect(remove_object_reference)

func _physics_process(_delta: float) -> void:
	# Only run if we actually have a valid target
	if current_target != null:
		track_target()

func track_target() -> void:
	# Update Raycast rotation and length
	var direction = pointer.global_position.direction_to(current_target.global_position)
	var distance = pointer.global_position.distance_to(current_target.global_position)
	
	pointer.target_position = Vector2(distance, 0)
	pointer.rotation = direction.angle()
	
	# Move the character
	# Note: Moving by 'global_position' is usually wrong (that's teleporting).
	# You usually want to move by direction * speed.
	velocity = direction * status.max_speed
	move_and_slide()

func get_object_reference(object: Node2D) -> void:
	# If it is a player, make it the current target
	if object.is_in_group("player"):
		current_target = object

func remove_object_reference(object: Node2D) -> void:
	# Only remove if the object leaving IS the one we are chasing
	if object == current_target:
		current_target = null
		# Optional: Reset velocity when target is lost
		velocity = Vector2.ZERO
