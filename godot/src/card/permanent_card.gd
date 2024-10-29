class_name PermanentCard 
extends Card
## Immutable PermanentCard Interface
##
## Represents a Card that when played creates a Permanent that will persist on the Battlefield

## Used for to_dict/from_dict for dynamic dispatch
static func DICT_TYPE() -> String : return "card.permanent"

## Callable[Permanent]
@export var permanent_spawner := func() -> Permanent: return Permanent.from_card(self)
@export var permanent_template: Permanent = Permanent.new()

## Observer Method[br]
## [param return] Returns instance of permanent that card represents
func spawn() -> Permanent:
	push_error("NotImplementedError: Permanent.spawn())")
	return Permanent.new()

## Observer method[br]
## [param return] Returns dictionary representation
func to_dict() -> Dictionary:
	if self is FollowerCard or self is FactoryCard:
		return self.to_dict()
	else:
		push_error("NotImplementedError: Permanent.to_dict()")
		return {}

static func from_dict(dict: Dictionary) -> PermanentCard:
	if dict["dict_type"] == FollowerCard.DICT_TYPE():
		return FollowerCard.from_dict(dict)
	elif dict["dict_type"] == FactoryCard.DICT_TYPE():
		return FactoryCard.from_dict(dict)
	else:
		push_error("NotImplementedError: PermanentCard.from_dict()")
		return PermanentCard.new()

func _init(p_card_name : String = "<Card Name>", p_card_text : String = "<Card Text>") -> void:
	card_name = p_card_name
	card_text = p_card_text
	self.permanent_template = self.permanent_spawner.call()
