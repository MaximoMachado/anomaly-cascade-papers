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

func shuffle() -> void:
	deck.shuffle()
	influence_deck.shuffle()
	graveyard.shuffle()

func add_to_hand(cards: Array[Card]) -> void:
	hand.append_array(cards)

func discard_from_hand(cards: Array[Card]) -> void:
	for card in cards:
		var index : int = hand.find(card)
		if index != -1:
			hand.remove_at(index)

## Adds main deck cards to your hand
func draw_cards(num_cards: = 1) -> void:
	for i in range(num_cards):
		var card := deck.pop_front()
		hand.append(card)

## Adds influence deck cards to your hand
func draw_influence_cards(num_cards: = 1) -> void:
	for i in range(num_cards):
		var card := influence_deck.pop_front()
		hand.append(card)

## Adds graveyard deck cards to your hand
func draw_graveyard_cards(num_cards: = 1) -> void:
	for i in range(num_cards):
		var card := graveyard.pop_front()
		hand.append(card)

func add_to_deck(cards: Array[Card]) -> void:
	for i in range(cards.size()):
		var card = cards[i]
		var random_index = randi() % deck.size()
		deck.insert(random_index, card)

func add_to_influence_deck(cards: Array[Card]) -> void:
	for i in range(cards.size()):
		var card = cards[i]
		var random_index = randi() % influence_deck.size()
		influence_deck.insert(random_index, card)

func add_to_graveyard(cards: Array[Card]) -> void:
	for i in range(cards.size()):
		var card = cards[i]
		var random_index = randi() % graveyard.size()
		graveyard.insert(random_index, card)



## Public Observers

func followers(deep_copy=false) -> Array[Follower]:
	return followers_in_play.duplicate(deep_copy)

func factories(deep_copy=false) -> Array[Factory]:
	return factories_in_play.duplicate(deep_copy)


## Private Methods