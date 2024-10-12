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


## Public Observers


## Private Methods