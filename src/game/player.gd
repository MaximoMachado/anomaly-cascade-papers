class_name Player
extends Resource


var player_id: int
var hand: Array[Card]
var main_deck: Deck
var influence_deck: Deck
var graveyard: Deck

var summoned_followers: Array[Follower]


func _init(p_hand: Array[Card], p_main_deck: Deck, p_influence_deck: Deck) -> void:
    pass
