extends Node2D

const card_view_scene := preload("res://scenes/card_view/card_view.tscn")
const follower_view_scene := preload("res://scenes/follower_view/follower_view.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MultiplayerManager.game_started.connect(_start_game)
	if MultiplayerManager.current_game != null:
		_start_game()

func _start_game() -> void:
	var game := MultiplayerManager.current_game

	for card in game.player(multiplayer.get_unique_id()).hand:
		var card_view := card_view_scene.instantiate()
		card_view.card = card
		$HandView.add_child(card_view)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_card_pressed() -> void:
	var selected_card : CardView = $HandView.selected_card
	if selected_card != null:
		var status : bool = MultiplayerManager.current_game.play_card(0, selected_card.card, [])
		if status:
			print_debug("Play card")
			if selected_card.card is Follower:
				var follower_view := follower_view_scene.instantiate()
				follower_view.follower = selected_card.card
				$FollowerZone.add_child(follower_view)
			
			$HandView.remove_child(selected_card)
		else:
			# TODO: Add error message that card can't be played
			print_debug("Can't play card")


func _on_end_turn_pressed() -> void:
	var status := MultiplayerManager.current_game.end_turn(0)
	if status:
		print_debug("End turn")
	else:
		print_debug("Can't end turn")
