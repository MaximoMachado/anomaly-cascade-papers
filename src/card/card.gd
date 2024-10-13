
class_name Card 
extends RefCounted
## Abstract Class that details stats of a card
## Any Resource must implement the methods below to be considered a 'Card' Resource

@export var card_image: Image = Image.load_from_file("res://assets/images/no_image.jpg")

## Name of the card presented to players
@export var card_name: String

## Explanation of card mechanics presented to players
@export_multiline var card_text: String

## Required cost to play this card
var flux: Flux

func _init() -> void:
	push_error("NotImplementedError: Card.new()")

## Mutators

## Plays card 
func play(targets: Array) -> bool:
	push_error("NotImplementedError: Card.play()")
	return false

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
