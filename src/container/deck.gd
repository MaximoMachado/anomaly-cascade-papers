class_name Deck 
extends RefCounted
## A deck of cards
## Representation: An array of cards
## Abstraction Function: card i in deck = _cards[i]
## Invariants: 0 <= _curr_index < _cards.size()


var _cards : Array[Card]

var _curr_index: int

var _automatically_shuffle: bool

func _init(p_cards: Array[Card] = [], p_shuffle := true) -> void:
	_cards = p_cards.duplicate(true)
	_automatically_shuffle = p_shuffle
	shuffle()


func shuffle() -> void:
	if _automatically_shuffle:
		_cards.shuffle()

## Draws a starting hand and removes these cards from the deck
## 
## @param num_cards: If deck has cards, will draw a maximum of that many cards
## @param num_factories: If deck has factories, will draw up to that many first
##
## @return 0 <= array.size() <= num_cards
func starting_hand(num_cards: int = 7, num_factories: int = 2) -> Array[Card]:
	var hand : Array[Card] = []

	# If requested cards is less than needed, simply return those cards
	if _cards.size() < num_cards:
		hand = _cards
		_cards = []
		return hand
	
	var factories : Array[Card] = _cards.filter(func(card: Card) -> bool: return card is Factory)
	if _automatically_shuffle:
		factories.shuffle()

	var guaranteed_factories : int = min(num_factories, factories.size())
	for i in range(0, guaranteed_factories):
		var factory := factories[i]
		hand.append(factory)
		var index := _cards.find(factory)
		_cards.remove_at(index)

	var cards_to_draw : int = max(0, num_cards - guaranteed_factories)
	for i in range(cards_to_draw):
		var card : Card = _cards.pop_front()
		hand.append(card)

	return hand

func draw_cards(num_cards: int, starting_index: int = 0) -> Array[Card]:
	var top_cards := _cards.slice(starting_index, num_cards)

	# Delete cards from deck
	for i in range(num_cards):
		_cards.pop_front()

	return top_cards

func shuffle_in_card(card: Card, position := -1) -> void:

	if position == -1:
		position = randi_range(0, _cards.size())

	print_debug(_cards.insert(position, card))


## Public Observers

## Immutable snapshot of cards of a deck
var cards : Array[Card]:
	get: return _cards.duplicate()
	set(value): pass
	
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

func duplicate(deep := false) -> Deck:
	return Deck.new(_cards.duplicate(deep))

func find(what: Card, from: int = 0) -> int:
	return _cards.find(what, from)

func has(value: Card) -> bool:
	return _cards.has(value)

func size() -> int:
	return _cards.size()

func all(method: Callable) -> bool:
	return _cards.all(method)

func any(method: Callable) -> bool:
	return _cards.any(method)
