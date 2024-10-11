class_name Game
extends Resource


var players: Array[Player]

def _init(player_ids: Array[int]) -> void:
    for i in player_ids:
        var player = Player.new(i)
        players.append(player)
