
class_name FollowerStats 
extends RefCounted
## Struct containing the basic stats of a Follower
## Defined by Attack, Influence, Max Health, and Health

## How much damage this follower deals
## attack >= 0
@export var attack: int :
	set(value): attack = maxi(0, value)

## How much influence this follower will gather
## influence = any integer
@export var influence: int :
	set(value): influence = value
		
## Max health value of follower
## max_health >= 0
@export var max_health: int :
	set(value):
		var health_change := value - max_health
		max_health = maxi(0, value)

		# Current health changes the same amount as max_health does
		health += health_change

## Current health of the follower
## 0 <= health <= max_health
@export var health: int :
	set(value):
		health = clamp(value, 0, max_health)

func _init(p_attack: int = 0, p_influence: int = 0, p_max_health: int = 0) -> void:
	attack = p_attack
	influence = p_influence
	max_health = p_max_health
	health = max_health
