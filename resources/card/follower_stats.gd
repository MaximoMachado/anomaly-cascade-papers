
class_name FollowerStats extends Resource

## Struct containing the basic stats of a Follower
## Defined by Attack, Influence, Max Health, and Current Health

# Non-negative, automatically clamped
@export var attack: int :
	set(value):
		if value < 0:
			push_warning("ValueWarning: Attack cannot be less than 0")
			attack = 0
		else:
			attack = value

# Unlike the others, it can be negative
@export var influence: int :
	set(value):
		influence = value
		
# Non-negative, automatically clamped
@export var max_health: int :
	set(value):
		if value < 0:
			push_warning("ValueWarning: Maximum health cannot be less than 0")
			max_health = 0
		else:
			max_health = value

var current_health: int

func _init(p_attack: int = 0, p_influence: int = 0, p_max_health: int = 0):
	attack = p_attack
	influence = p_influence
	max_health = p_max_health
	current_health = max_health
