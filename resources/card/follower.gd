class_name Follower extends Card
## Represents the follower card type, equivalent to Hearthstone's Minion type
## When played from hand, it is summoned onto the board on player's side

signal follower_died(follower: Follower)

@export var stats: FollowerStats

## 
## @emit If follower dies from this attack
## @return Whether follower dies from this attack
func recieve_damage(damage_dealers: Array[Follower], damage: int) -> bool:
	stats.health -= damage
	var has_died := is_dead()
	if is_dead:
		follower_died.emit(self)
	return has_died
	
##
## @returns how much damage each defender should recieve
##			e.g. defenders[i].recieve_damage([attacker], return[i])
func attack(defenders: Array[Follower]) -> Array[int]:
	push_error("NotImplementedError: Follower.attack()")
	return []

## 
## @returns how much damage each defender should recieve
##			e.g. attackers[i].recieve_damage([attacker], return[i])
func block(attackers: Array[Follower]) -> Array[int]:
	push_error("NotImplementedError: Follower.block()")
	return []
	
##
## @returns how much influence to attain
func influence() -> int:
	push_error("NotImplementedError: Follower.influence()")
	return 0
	
func is_dead() -> bool:
	return stats.health <= 0

func _init(p_card_name := "<Card Name>", \
			p_card_text := "<Card Text>", \
			p_follower_stats : FollowerStats = null) -> void:
	card_name = p_card_name
	card_text = p_card_text
	
	if p_follower_stats == null:
		stats = FollowerStats.new()
	else:
		stats = p_follower_stats
