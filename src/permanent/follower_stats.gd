
class_name FollowerStats 
extends Resource
## Immutable Struct containing the basic stats of a Follower
## Defined by Attack, Influence, Max Health, and Health

static var DICT_TYPE := "follower_stats"

## How much damage this follower deals
## attack >= 0
var attack: int :
	get: return _attack
	set(value): _attack = Types.read_only(_attack, value)

## How much influence this follower will gather
## influence = any integer
var influence: int :
	get: return _influence
	set(value): _influence = Types.read_only(_influence, value)
		
## Max health value of follower
## max_health >= 0
var max_health: int :
	get: return _max_health
	set(value): _max_health = Types.read_only(_max_health, value)

## Current health of the follower
## 0 <= health <= max_health
var health: int :
	get: return _health
	set(value): _health = Types.read_only(_health, value)

@export var _attack: int = 0:
	set(value): attack = maxi(0, value)

@export var _influence: int = 0:
	set(value): influence = value

@export var _max_health: int = 0:
	set(value):
		max_health = maxi(0, value)
		# Clamp health down to new value
		health = clamp(value, 0, max_health)

@export var _health: int = 0:
	set(value):
		health = clamp(value, 0, max_health)

func to_dict() -> Dictionary:
	var stats_dict := {}
	stats_dict["dict_type"] = DICT_TYPE
	stats_dict["attack"] = attack
	stats_dict["influence"] = influence
	stats_dict["max_health"] = max_health
	stats_dict["health"] = health

	return stats_dict

static func from_dict(stats_dict: Dictionary) -> FollowerStats:

	var stats := FollowerStats.new()
	stats.attack = stats_dict["attack"]
	stats.influence = stats_dict["influence"]
	stats.max_health = stats_dict["max_health"]
	stats.health = stats_dict["health"]

	return stats

func _init(p_attack: int = 0, p_influence: int = 0, p_max_health: int = 0) -> void:
	attack = p_attack
	influence = p_influence
	max_health = p_max_health
	health = max_health
