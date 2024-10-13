
class_name Lobby extends RefCounted

var _players: Array[PlayerInfo] = []
var players: Array[PlayerInfo] :
	get: return _players.duplicate()
	set(value): _players = Types.read_only(_players, value)

## TODO: Add way to configure Game Settings
#var game_config: GameConfig

## TODO: Add teams/multiple player support 
## Maps player_id to team_id
#var _team_to_players: Dictionary

func add_player(p_player: PlayerInfo):
    _players.append(p_player)
    return true

func has(p_player: PlayerInfo) -> bool:
    var ids : int = _players.map(func(player: PlayerInfo) -> int: return player.id)

    return ids.has(p_player.id)