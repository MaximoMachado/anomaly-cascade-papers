class_name Deck 
extends RefCounted
## Array-wrapper that represents a deck of cards 


var _cards : Array[Card]

var _curr_index: int

func _init(p_cards: Array[Card] = []) -> void:
	_cards = p_cards.duplicate(true)


## Fisher-yates in-place shuffle
func shuffle() -> void:
	var rng := RandomNumberGenerator.new()
	var n := _cards.size()
	for i in range(n-1, 1, -1):
		var j := rng.randi_range(0, i)

		var tmp_card := _cards[i]
		_cards[i] = _cards[j]
		_cards[j] = tmp_card
	
# To implement iterating over the Deck

func _iter_init() -> bool:
	_curr_index = 0
	return _curr_index < _cards.size()

func _iter_next() -> bool:
	_curr_index += 1
	return _curr_index < _cards.size()

func _iter_get() -> Card:
	return _cards[_curr_index]

# Useful Array methods to use as-is

func find(what: Card, from: int = 0) -> int:
	return _cards.find(what, from)

func has(value: Card) -> bool:
	return _cards.has(value)

func pop_front() -> Card:
	return _cards.pop_front()

func pop_back() -> Card:
	return _cards.pop_back()

func size() -> int:
	return _cards.size()

func all(method: Callable) -> bool:
	return _cards.all(method)

func any(method: Callable) -> bool:
	return _cards.any(method)
