class_name Player
extends RefCounted


var id: int
var team_id: int
var hand: Array[Card]
var deck: Deck
var influence_deck: Deck
var graveyard: Deck

var followers_in_play: CardZone
var factories_in_play: CardZone

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

func _init(p_id: int, p_main_deck: Deck = Deck.new(), p_influence_deck: Deck = Deck.new(), p_hand: Array[Card] = [],) -> void:
	id = p_id
	team_id = p_id
	hand = p_hand
	deck = p_main_deck
	influence_deck = p_influence_deck
	graveyard = Deck.new()

	if p_hand.size() == 0:
		hand = deck.starting_hand()

## Mutators

func shuffle() -> Player:
	deck.shuffle()
	influence_deck.shuffle()
	graveyard.shuffle()
	return self

## Adds card to hands
func add_to_hand(cards: Array[Card]) -> Player:
	hand.append_array(cards)
	return self

## Removes card from hand
func discard_from_hand(cards: Array[Card]) -> Plyaer:
	for card in cards:
		var index : int = hand.find(card)
		if index != -1:
			hand.remove_at(index)

	return self

## Removes top N cards from deck
func draw_cards(num_cards: = 1) -> Array[Card]:
	return _draw_cards_from_deck(num_cards, deck)

## Removes top N cards from deck
func draw_influence_cards(num_cards: = 1) -> Array[Card]:
	return _draw_cards_from_deck(num_cards, influence_deck)

## Removes top N cards from deck
func draw_graveyard_cards(num_cards: = 1) -> Array[Card]:
	return _draw_cards_from_deck(num_cards, graveyard)

func add_to_deck(cards: Array[Card]) -> Player:
	return _add_to_deck(cards, deck)

func add_to_influence_deck(cards: Array[Card]) -> Player:
	return _add_to_deck(cards, influence_deck)

func add_to_graveyard(cards: Array[Card]) -> Player:
	return _add_to_deck(cards, graveyard)

## Public Observers

func get_playable_cards() -> Array[Card]:
	return hand.filter(func(card: Card) -> bool: return card.is_playable(self))

func followers(deep_copy := false) -> Array[Follower]:
	return followers_in_play.duplicate(deep_copy)

func factories(deep_copy := false) -> Array[Factory]:
	return factories_in_play.duplicate(deep_copy)


## Private Methods

func _draw_cards_from_deck(num_cards: int, p_deck: Deck) -> Array[Card]:
	var cards : Array[Card] = []
	for i in range(num_cards):
		var card := p_deck.pop_front()
		cards.append(card)
	return cards

func _add_to_deck(cards: Array[Card], p_deck: Deck) -> Player:
	for i in range(cards.size()):
		var card = cards[i]
		var random_index = randi() % p_deck.size()
		deck.insert(random_index, card)

	return self
