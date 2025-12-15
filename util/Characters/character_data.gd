class_name CharacterData
extends Resource

# --- Shared Stats ---
@export_group("Movement")
@export_range(100, 2000) var max_speed: float = 100
@export_range(50, 2000) var speed: float = 50
@export var accelerate := 1200.0
@export var decelerate := 1000.0
@export var ground_friction_factor := 10.0 # Fixed typo "fiction" to "friction"

@export_group("Combat")
@export_range(0, 1000) var health : int = 100
@export_range(0, 1000) var attack: int = 100
@export_range(0, 1000) var dexterity: int

enum STATES {IDLE, WALK, WORK}
