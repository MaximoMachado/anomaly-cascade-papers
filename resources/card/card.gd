
class_name Card extends Resource
## Abstract Class that details stats of a card
## Any Resource must implement the methods below to be considered a 'Card' Resource

@export var card_image: Texture

## Name of the card presented to players
@export var card_name: String

## Explanation of card mechanics presented to players
@export var card_text: String

## Required cost to play this card
@export var flux: Flux

## Plays card for target player onto the board
func play(player: int, board: int) -> void:
	push_error("NotImplementedError: Card.play()")

## Returns a copy of the card for modification
func copy() -> Card:
	push_error("NotImplementedError: Card.copy()")
	return Card.new()
	
func _init() -> void:
	push_error("NotImplementedError: Card.new()")
