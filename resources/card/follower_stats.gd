
class_name FollowerStats extends Resource
## Struct containing the basic stats of a Follower
## Defined by Attack, Influence, Max Health, and Health

## How much damage this follower deals
## Non-negative
@export var attack: int :
	set(value):
		if value < 0:
			push_warning("ValueWarning: Attack cannot be less than 0")
			attack = 0
		else:
			attack = value

## How much influence this follower will gather
## Unlike the others, it can be negative
@export var influence: int :
	set(value):
		influence = value
		
## Max health value of follower
## Non-negative
@export var max_health: int :
	set(value):
		if value < 0:
			push_warning("ValueWarning: Maximum health cannot be less than 0")
			max_health = 0
		else:
			max_health = value
		
		# Update current health
		health = clamp(health, 0, max_health)

## Current health of the create
## 0 <= health <= max_health
@export var health: int :
	set(value):
		health = clamp(value, 0, max_health)

func _init(p_attack: int = 0, p_influence: int = 0, p_max_health: int = 0) -> void:
	attack = p_attack
	influence = p_influence
	max_health = p_max_health
	health = max_health
