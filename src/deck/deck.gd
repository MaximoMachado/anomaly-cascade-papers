class_name Deck 
extends RefCounted
## Array-wrapper that represents a deck of cards 


var _cards : Array[Card]

var _curr_index: int

func _init(p_cards: Array[Card] = [], shuffle := true) -> void:
	_cards = p_cards.duplicate(true)
	if shuffle:
		shuffle()


func shuffle() -> void:
	_cards.shuffle()

## Removes 7 cards from the deck and returns them
## The first two cards of the 7 will be Factories
func get_starting_hand(num_cards: int = 5, num_factories: int = 2) -> Array[Card]:
	var hand : Array[Card] = []

	if _cards.size() < 7:
		hand = _cards
		_cards = []
		return hand
	
	var factories : Array[Factory] = _cards.filter(func(card: Card) -> bool: return card is Factory)
	factories.shuffle()
	for i in range(0, num_factories):
		var factory := factories[i]
		hand.append(factory)
		var index := _cards.find(factory)
		_cards.remove_at(index)

	for i in range(0, num_cards):
		var card : Card = _cards.pop_front()
		hand.append(card)

	return hand

func draw_cards(num_cards: int, starting_index: int = 0) -> Array[Card]:
	var top_cards := _cards.slice(starting_index, num_cards)

	# Delete cards from deck
	for i in range(num_cards):
		_cards.pop_front()

	return top_cards
	
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

func insert(position: int, value: Card) -> int:
	return _cards.insert(position, value)

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
