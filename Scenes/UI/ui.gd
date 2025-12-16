extends CanvasLayer

@onready var health_bar: ProgressBar = %HealthBar
@onready var label: Label = $Label
var player: CharacterBody2D

func _ready() -> void:
	#initial current player
	player = owner.find_child("Player")
	#Update current player when accessing to another scene
	
	owner.player_changed.connect(updatePlayer)
	player.status.health_changed.connect(updateHealth)
	health_bar.value = player.status.health
	label.text = str(1.0 + (1.0 - (health_bar.value / 100)) * 2.0) + " / 1.0"

func updatePlayer(next_player):
	player = next_player

func updateHealth(health: float):
	health_bar.value = health
	var mapped = 1.0 + (1.0 - (health / 100)) * 2.0
	label.text = str(mapped) + " / 1.0"
