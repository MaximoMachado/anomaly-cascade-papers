
class_name Target extends RefCounted

var _target : Variant = null

func create_target_player(player_id: int) -> Target:
	var target := Target.new()
	target._target = player_id
	return target

func create_target_card(card: Card) -> Target:
	var target := Target.new()
	target._target = card
	return target

func get_target() -> Variant:
	return _target
