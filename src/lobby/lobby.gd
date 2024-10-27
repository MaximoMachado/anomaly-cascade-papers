
class_name Lobby 
extends RefCounted
## Represents a Lobby that players can join
##
## Mutable data structure
## Game can be customized before being started

@export var id := 0

@export var host_player : PlayerInfo = PlayerInfo.new()

## TODO: Add way to configure Game Settings
@export var game_config: GameConfig = GameConfig.new()

var players: Array[PlayerInfo] :
	get: return _players.duplicate()
	set(value): _players = Types.read_only(_players, value)

@export var _players: Array[PlayerInfo] = []

## TODO: Add teams/multiple player support 
## Maps player_id to team_id
#var _team_to_players: Dictionary

## Creates Lobby with a default ID derived from [param host_player]
static func create(host_player: PlayerInfo) -> Lobby:
	var lobby := Lobby.new()
	lobby.id = host_player.id
	lobby.add_player(host_player)
	lobby.host_player = host_player
	return lobby


## Adds player to lobby
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
	for player in _players:
		if player.id == player_id:
			return true

	return false

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
