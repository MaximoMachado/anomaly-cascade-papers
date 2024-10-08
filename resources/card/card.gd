
class_name Card extends Resource
## Abstract Class that details stats of a card
## Any Resource must implement the methods below to be considered a 'Card' Resource

## Name of the card presented to players
@export var card_name: String

## Explanation of card mechanics presented to players
@export var card_text: String

## Required cost to play this card
@export var flux: Flux


func play() -> void:
	push_error("NotImplementedError: Card.play()")
	
func _init():
	push_error("NotImplementedError: Card.new()")
