extends CanvasLayer

@onready var health_bar: ProgressBar = %HealthBar
var player: CharacterBody2D

func _ready() -> void:
	#initial current player
	player = owner.find_child("Player")
	#Update current player when accessing to another scene
	owner.player_changed.connect(updatePlayer)
	player.status.health_changed.connect(updateHealth)
	health_bar.value = player.status.health

func updatePlayer(next_player):
	player = next_player

func updateHealth(health: int):
	health_bar.value = health
