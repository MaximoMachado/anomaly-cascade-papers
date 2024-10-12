class_name Player
extends RefCounted


var id: int
var hand: Array[Card]
var deck: Deck
var influence_deck: Deck
var graveyard: Deck

var followers_in_play: Zone
var factories_in_play: Zone

var health : int:
	set(value):
		if value < 0:
			health = 0
		else:
			health = value

var influence : int:
	set(value):
		if value < 0:
			influence = 0
		else:
			influence = value

func _init(p_id: int, p_hand: Array[Card] = [], p_main_deck: Deck = Deck.new(), p_influence_deck: Deck = Deck.new()) -> void:
	id = p_id
	hand = p_hand
	deck = p_main_deck
	influence_deck = p_influence_deck
	graveyard = Deck.new()

	if p_hand.size() == 0:
		hand = deck.get_starting_hand()

## Mutators

func add_to_hand(cards: Array[Card]) -> void:
	pass

func discard_from_hand(cards: Array[Card]) -> void:
	pass

func draw_cards(num_cards: = 1) -> Array[Card]:
	pass

func draw_influence_cards(num_cards: = 1) -> Array[Card]:
	pass

func draw_graveyard_cards(num_cards: = 1) -> Array[Card]:
	pass

func add_to_deck(cards: Array[Card]) -> void:
	pass

func add_to_influence_deck(cards: Array[Card]) -> void:
	pass

func add_to_graveyard(cards: Array[Card]) -> void:
	pass





## Public Observers


## Private Methods