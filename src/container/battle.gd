class_name Battle extends RefCounted

var attackers: Array[Follower] = []
var blockers: Array[Follower] = []

## Producers

func to_dict() -> Dictionary:
	var deck_dict := {}
	deck_dict["attackers"] = blockers.map(Types.to_dict)
	deck_dict["blockers"] = attackers.map(Types.to_dict)
	return deck_dict

static func from_dict(battle_dict: Dictionary) -> Battle:
	var battle := Battle.new()
	battle.attackers = battle_dict["attackers"].map(Follower.from_dict)
	battle.blockers = battle_dict["blockers"].map(Follower.from_dict)
	return battle

## Mutators

func add_attacker(follower: Follower) -> Battle:
	attackers.append(follower)
	return self

func add_blocker(follower: Follower) -> Battle:
	blockers.append(follower)
	return self

func remove_attacker(follower: Follower) -> Battle:
	var index := attackers.find(follower)
	attackers.remove_at(index)
	return self

func remove_blocker(follower: Follower) -> Battle:
	var index := blockers.find(follower)
	blockers.remove_at(index)
	return self

## Mutates attacking and defending followers to deal damage to each other
func damage_step() -> Battle:

	var damage_dealt_to_blockers: Array[int] = _calculate_damage(attackers, blockers)

	var damage_dealt_to_attackers: Array[int] = _calculate_damage(blockers, attackers)

	# Update health of attackers/blockers
	for i in range(attackers.size()):
		attackers[i].recieve_battle_damage(blockers, damage_dealt_to_attackers[i])

	for i in range(blockers.size()):
		blockers[i].recieve_battle_damage(attackers, damage_dealt_to_blockers[i])

	return self

func _calculate_damage(damage_dealers: Array[Follower], damage_takers: Array[Follower]) -> Array[int]:
	var total_damage: Array[int] = []
	total_damage.resize(damage_takers.size())
	total_damage.fill(0)

	for i in range(damage_dealers.size()):
		var attacker := damage_dealers[i]
		var damage_dealt := attacker.attack(damage_takers)
		for j in range(damage_dealt.size()):
			damage_dealt[j] += damage_dealt[j]

	return total_damage

	