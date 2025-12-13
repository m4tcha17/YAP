class_name BASE
extends Resource

@export_range(500, 2000) var max_speed: float
@export_range(100, 2000) var speed: float
@export_range(0, 1000) var attack: int
@export_range(0, 1000) var dexterity: int


@export var ground_fiction_factor := 10.0
@export var accelerate := 1200.0
@export var decelerate := 1000.0

#instensity of the force to bounce back when colliding with any objects
@export_range(1, 100000) var avoidance_strength := 21000.0

# Stores objects that enter the "Collision Area"
# Collision Area: pushes away the mob from the objects that are listed on the lists
var object_list : CharacterBody2D
var pointer : RayCast2D


enum STATES {IDLE, WALK, WORK}
