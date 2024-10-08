class_name Follower extends Card
## Represents the follower card type, equivalent to Hearthstone's Minion type
## When played from hand, it is summoned onto the board on player's side

signal follower_died(follower: Follower)

@export var follower_stats: FollowerStats

## 
## @emit If follower dies from this attack
## @return Whether follower dies from this attack
func recieve_damage(attackers: Array[Follower], damage: int) -> bool:
	push_error("NotImplementedError: Follower.recieve_damage()")
	return false
	
##
## @returns how much damage each defender should recieve
##			e.g. defenders[i].recieve_damage([attacker], return[i])
func deal_damage(defenders: Array[Follower]) -> Array[int]:
	push_error("NotImplementedError: Follower.deal_damage()")
	return []

func _init(p_card_name := "<Card Name>", \
			p_card_text := "<Card Text>", \
			p_follower_stats : FollowerStats = null) -> void:
	card_name = p_card_name
	card_text = p_card_text
	
	if p_follower_stats == null:
		follower_stats = FollowerStats.new()
	else:
		follower_stats = p_follower_stats
