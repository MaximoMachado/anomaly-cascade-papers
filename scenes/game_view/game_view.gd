extends Node2D

const card_view_scene := preload("res://scenes/card_view/card_view.tscn")
var lobby := Lobby.new()
var game: Game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var test_deck = Deck.new()
	for i in range(0):
		test_deck.shuffle_in_card(Follower.new(str(i), str(i), FollowerStats.new(1, 1, 1)))
		
	for i in range(2):
		var player = PlayerInfo.new(i, "")
		player.deck = test_deck.duplicate()
		lobby.add_player(player)
		
	game = Game.new(lobby)
	
	for card in game._players[0].hand:
		var card_view := card_view_scene.instantiate()
		card_view.card = card
		$"%CardContainer".add_child(card_view)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
