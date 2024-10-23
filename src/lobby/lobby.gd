
class_name Lobby extends RefCounted

var lobby_id := 0
var _players: Array[PlayerInfo] = []
var players: Array[PlayerInfo] :
	get: return _players.duplicate()
	set(value): _players = Types.read_only(_players, value)
var game_config: GameConfig = GameConfig.new()

## TODO: Add way to configure Game Settings
#var game_config: GameConfig

## TODO: Add teams/multiple player support 
## Maps player_id to team_id
#var _team_to_players: Dictionary

func add_player(p_player: PlayerInfo) -> bool:
	_players.append(p_player)
	return true

func remove_player(player_id: int) -> bool:
	_players = _players.filter(func(player: PlayerInfo) -> bool: return player.id != player_id)
	return true

func has(player_id: int) -> bool:
	var ids : Array[int] = _players.map(func(player: PlayerInfo) -> int: return player.id)

	return ids.has(player_id)

func to_dict() -> Dictionary:
	var dict := {}

	dict["lobby_id"] = lobby_id
	var players = []
	for player in _players:
		players.append(player.to_dict())
	dict["players"] = players

	# Todo: Serialize game config
	#dict["game_config"] :=

	return dict

static func from_dict(lobby_dict: Dictionary) -> Lobby:
	var lobby := Lobby.new()
	# for player in lobby_dict["players"]:
	# 	lobby._players.append(Player.from_dict(player))

	lobby.lobby_id = lobby_dict["lobby_id"]

	return lobby