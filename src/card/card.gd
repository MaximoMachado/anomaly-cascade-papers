
class_name Card 
extends Resource
## Abstract Interface Class that details stats of a card
## Any Resource must implement the methods below to be considered a 'Card' Resource

## Path to a resource that will be loaded as the artwork for this particular card
@export var card_image_path: String = "res://assets/images/no_image.jpg"

## Name of the card that is to be displayed
@export var card_name: String = ""

## Explanation of the card's mechanics presented to players
@export_multiline var card_text: String = ""

## Required cost to play this card
@export var flux: Flux = Flux.new()

func _init() -> void:
	push_error("NotImplementedError: Card.new()")

## Mutators

## Plays card 
func play(targets: Array) -> bool:
	push_error("NotImplementedError: Card.play()")
	return false

## Producers

func to_dict() -> Dictionary:
	if self is Follower or self is Catalyst or self is Factory:
		return self.to_dict()
	else:
		push_error("NotImplementedError: Card.to_dict()")
		return {}


static func from_dict(card_dict: Dictionary) -> Card:
	match card_dict["dict_type"]:
		Follower.DICT_TYPE:
			return Follower.from_dict(card_dict)
		Factory.DICT_TYPE:
			return Factory.from_dict(card_dict)
		Catalyst.DICT_TYPE:
			return Catalyst.from_dict(card_dict)
		HiddenCard.DICT_TYPE:
			return HiddenCard.from_dict(card_dict)
		_:
			push_error("NotImplementedError: Card.from_dict()")
			return Card.new()

## Returns a copy of the card for modification
func copy() -> Card:
	push_error("NotImplementedError: Card.copy()")
	return Card.new()

## Public Observers

func is_playable(player: Player) -> bool:
	push_error("NotImplementedError: Card.is_playable()")
	return false

func valid_targets(targets: Array) -> Array:
	var valid_targets := []
	for target in targets:
		if Types.is_target(target):
			valid_targets.append(target)

	return valid_targets

## Calls query on card and returns true if it matches query conditions
# func query(card_query: CardQuery) -> bool:
# 	pass
