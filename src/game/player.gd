class_name Player
extends Resource


var id: int
var hand: Array[Card]
var main_deck: Deck
var influence_deck: Deck
var graveyard: Deck

var summoned_followers: Array[Follower]


func _init(p_id: int, p_hand: Array[Card] = [], p_main_deck: Deck = Deck.new(), p_influence_deck: Deck = Deck.new()) -> void:
    id = p_id
    hand = p_hand
    main_deck = p_main_deck
    influence_deck = p_influence_deck
    graveyard = Deck.new()
