

class_name Permanent 
extends Resource
## Permanent Interface Class. Do not create directly.
##
## This represents anything that lives on the battlefield. Factories, Followers, Token Followers, etc.

## This represents what the permanent's derived card is. Used for tooltips
@export var card: Card = HiddenCard.new()

func _init() -> void:
	push_error("NotImplementedError: Card.new()")

## Mutator method[br]
## Attempts to play card with specified targets[br]
## [param param targets] Will mutate targets acoording to the on-play effects of the card[br]
## [param return] Whether this card was able to be played
func exhaust(targets: Array) -> bool:
	push_error("NotImplementedError: Card.play()")
	return false

## Observer method[br]
## [param return] Dictionary with value-based semantics of card's state
func to_dict() -> Dictionary:
	if self is Follower or self is Catalyst or self is Factory:
		return self.to_dict()
	else:
		push_error("NotImplementedError: Card.to_dict()")
		return {}

## Creator method[br]
## Converts a dictionary to a card based on "dict_type" field
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

## Observer method[br]
## [param return] Whether card is playable for player
func is_playable(player: Player) -> bool:
	push_error("NotImplementedError: Card.is_playable()")
	return false

## Observer method[br]
## [param return] An array of potential targets
func valid_targets(targets: Array) -> Array:
	var valid_targets := []
	for target in targets:
		if Types.is_target(target):
			valid_targets.append(target)

	return valid_targets
