class_name Game
extends Resource

var players: Array[Player]
var id_to_player: Dictionary

func _init(player_ids: Array[int]) -> void:
	for i in player_ids:
		var player := Player.new(i)
		players.append(player)
		id_to_player[i] = player

func play_card(player_id: int, card: Card) -> void:
	var player := id_to_player[player_id]
	player.hand.find(card)
