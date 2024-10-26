
class_name Lobby extends RefCounted
## Represents a Lobby that players can join
## Game can be customized before being started
## Mutable data structure

var id := 0
var _players: Array[PlayerInfo] = []
var players: Array[PlayerInfo] :
	get: return _players.duplicate()
	set(value): _players = Types.read_only(_players, value)

var host_player : PlayerInfo = null

## TODO: Add way to configure Game Settings
var game_config: GameConfig = GameConfig.new()


## TODO: Add teams/multiple player support 
## Maps player_id to team_id
#var _team_to_players: Dictionary

## Creates Lobby with a default ID derived from Host
static func create(host_player: PlayerInfo) -> Lobby:
	var lobby := Lobby.new()
	lobby.id = host_player.id
	lobby.add_player(host_player)
	lobby.host_player = host_player
	return lobby


func add_player(p_player: PlayerInfo) -> bool:
	_players.append(p_player)
	return true

func remove_player(player_id: int) -> bool:
	var removed := false
	for i in range(players.size()):
		var player := players[i]
		if player.id == player_id:
			players.remove_at(i)
			removed = true

	return removed

func has(player_id: int) -> bool:
	var ids : Array[int] = _players.map(func(player: PlayerInfo) -> int: return player.id)

	return ids.has(player_id)

func to_dict() -> Dictionary:
	var dict := {}

	dict["lobby_id"] = id
	dict["players"] = []
	for player in _players:
		dict["players"].append(player.to_dict())

	# Todo: Serialize game config
	#dict["game_config"] :=

	return dict

static func from_dict(lobby_dict: Dictionary) -> Lobby:
	var lobby := Lobby.new()

	lobby.id = lobby_dict["lobby_id"]
	for player: Dictionary in lobby_dict["players"]:
		lobby._players.append(PlayerInfo.from_dict(player))

	return lobby
