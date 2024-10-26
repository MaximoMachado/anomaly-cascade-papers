class_name Player
extends RefCounted


var id: int = 0
var team_id: int = 0
var hand: Array[Card] = []
var deck: Deck = Deck.new()
var influence_deck: Deck = Deck.new()
var graveyard: Deck = Deck.new()

var followers_in_play: Array[Follower] = []
var factories_in_play: Array[Factory] = []

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

func _init(p_id:int, p_main_deck: Deck = Deck.new(), p_influence_deck: Deck = Deck.new(), p_hand: Array[Card] = [], p_graveyard := Deck.new()) -> void:
	id = p_id
	team_id = p_id # TODO: Implement teams
	hand = p_hand.duplicate()
	deck = p_main_deck.duplicate()
	influence_deck = p_influence_deck.duplicate()
	graveyard = p_graveyard.duplicate()
	health = 20
	influence = 0

## Producers

## Constructs a player who has been given a starting hand
static func create_player_with_starting_hand(player_info: PlayerInfo, num_cards := 7, num_factories := 2) -> Player:
	var player = Player.new(player_info.id, player_info.deck, player_info.influence_deck)
	player.hand = player.deck.starting_hand(num_cards, num_factories)

	return player

func to_dict() -> Dictionary:
	var player_dict = {}
	player_dict["id"] = id
	player_dict["team_id"] = id
	player_dict["hand"] = hand.map(Types.to_dict)
	player_dict["deck"] = deck.to_dict()
	player_dict["influence_deck"] = influence_deck.to_dict()
	player_dict["graveyard"] = graveyard.to_dict()
	player_dict["followers"] = followers_in_play.map(Types.to_dict)
	player_dict["factories"] = factories_in_play.map(Types.to_dict)

	player_dict["health"] = health
	player_dict["influence"] = influence

	return player_dict

static func from_dict(player_dict: Dictionary) -> Player:
	var player = Player.new(player_dict["id"])
	player.team_id = player_dict["team_id"]

	player.hand.assign(player_dict["hand"].map(Card.from_dict))

	player.deck = Deck.from_dict(player_dict["deck"])
	player.influence_deck = Deck.from_dict(player_dict["influence_deck"])
	player.graveyard = Deck.from_dict(player_dict["graveyard"])

	player.followers_in_play.assign(player_dict["followers"].map(Follower.from_dict))
	player.factories_in_play.assign(player_dict["factories"].map(Factory.from_dict))

	player.health = player_dict["health"]
	player.influence = player_dict["influence"]
	return player


## TODO: Implement duplicate
func duplicate() -> Player:
	var new_player := Player.new(id, deck, influence_deck, hand, graveyard)

	return new_player

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
func discard_from_hand(cards: Array[Card]) -> Player:
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
		var card : Card = p_deck._cards.pop_front()
		cards.append(card)
	return cards

func _add_to_deck(cards: Array[Card], p_deck: Deck) -> Player:
	for i in range(cards.size()):
		var card = cards[i]
		var random_index = randi() % p_deck.size()
		deck.insert(random_index, card)

	return self
