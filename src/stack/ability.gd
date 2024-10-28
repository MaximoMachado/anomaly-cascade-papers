
class_name Ability 
extends Resource
## Immutable Ability that can live on the stack
##
## Represents an effect that mutates game state (such as targets) and can have conditions that cause it to not resolve
## Effects are typically attached to cards or abilities that control when the effect is triggered

## Required cost to activate this ability
@export var flux: Flux = Flux.new()

@export var effects : Array[CardEffect] = []

@export var speed := Enums.StackSpeed.SLOW

static func make_empty() -> Ability:
	return Ability.new()

func can_resolve() -> bool:
	# TODO
	return false

func resolve():
	# TODO
	pass