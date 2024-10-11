class_name Game
extends RefCounted

var players: Array[Player]
var id_to_player: Dictionary

func _init(player_ids: Array[int]) -> void:
	for i in player_ids:
		var player := Player.new(i)
		players.append(player)
		id_to_player[i] = player

## Player Actions

func end_turn():
	pass

func play_card(player_id: int, card: Card) -> void:
	var player := id_to_player[player_id]
	player.hand.find(card)



## Mutates attacking and defending followers 
func _deal_damage(attackers: Array[Follower], defenders: Array[Follower]) -> void:
	var damage_dealt_to_defenders: Array[int] = []
	damage_dealt_to_defenders.resize(defenders.size())
	damage_dealt_to_defenders.fill(0)
	
	for i in range(attackers.size()):
		var attacker := attackers[i]
		var damage_dealt := attacker.attack(defenders)
		for j in range(damage_dealt.size()):
			damage_dealt_to_defenders[j] += damage_dealt[j]
		
	
	var damage_dealt_to_attackers: Array[int] = []
	damage_dealt_to_attackers.resize(attackers.size())
	damage_dealt_to_attackers.fill(0)
	
	for i in range(defenders.size()):
		var defender := defenders[i]
		var damage_dealt := defender.block(attackers)
		for j in range(damage_dealt.size()):
			damage_dealt_to_attackers[j] += damage_dealt[j]
	
	# Update health of attackers/defenders
	for i in range(attackers.size()):
		attackers[i].recieve_battle_damage(defenders, damage_dealt_to_attackers[i])

	for i in range(defenders.size()):
		defenders[i].recieve_battle_damage(attackers, damage_dealt_to_defenders[i])
