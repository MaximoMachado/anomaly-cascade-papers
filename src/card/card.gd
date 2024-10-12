
class_name Card 
extends RefCounted
## Abstract Class that details stats of a card
## Any Resource must implement the methods below to be considered a 'Card' Resource

@export var card_image: Texture

## Name of the card presented to players
@export var card_name: String

## Explanation of card mechanics presented to players
@export_multiline var card_text: String

## Required cost to play this card
var flux: Flux

## Plays card 
func play(targets: Array[Target]) -> bool:
	push_error("NotImplementedError: Card.play()")
	return false

## Returns a copy of the card for modification
func copy() -> Card:
	push_error("NotImplementedError: Card.copy()")
	return Card.new()
	
func _init() -> void:
	push_error("NotImplementedError: Card.new()")
