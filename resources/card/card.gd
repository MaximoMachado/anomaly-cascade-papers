
class_name Card extends Resource
## Abstract Class that details stats of a card
## Any Resource must implement the methods below to be considered a 'Card' Resource

enum CardType { Factory, Follower, Action }

@export var card_name: String
@export var card_text: String
@export var card_type: CardType

func play() -> void:
	push_error("NotImplementedError: Card.play()")
	
