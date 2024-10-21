extends Node2D

const card_view_scene := preload("res://scenes/card_view/card_view.tscn")
var lobby := Lobby.new()
var game: Game
var player_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var test_deck = Deck.new()
	for i in range(50):
		test_deck.shuffle_in_card(Follower.new(str(i), str(i), FollowerStats.new(1, 1, 1)))
		
	for i in range(2):
		var player = PlayerInfo.new(i, "")
		player.deck = test_deck.duplicate()
		lobby.add_player(player)
		
	game = Game.new(lobby)
	for card in game._players[0].hand:
		var card_view := card_view_scene.instantiate()
		card_view.card = card
		$HandView.add_child(card_view)

	var status := game.start_game()
	assert(status)
	assert(game.mulligan(0, []))
	assert(game.mulligan(1, []))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_card_pressed() -> void:
	var selected_card : CardView = $HandView.selected_card
	if selected_card != null:
		var status : bool = game.play_card(0, selected_card.card, [])
		if status:
			print_debug("Play card")
			$HandView.remove_child(selected_card)
			if selected_card.card is Follower:
				$FollowerZone.add_child(selected_card)
		else:
			# TODO: Add error message that card can't be played
			print_debug("Can't play card")


func _on_end_turn_pressed() -> void:
	var status := game.end_turn(0)
	if status:
		print_debug("End turn")
	else:
		print_debug("Can't end turn")
