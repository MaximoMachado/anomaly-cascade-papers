class_name Follower extends Card
## Represents the follower card type, equivalent to Hearthstone's Minion type
## When played from hand, it is summoned onto the board on player's side

signal follower_died(follower: Follower)

@export var stats: FollowerStats

## Handles recieving damage from any card
## @emit If follower dies from this attack
## @return Whether this follower dies from this attack
func recieve_damage(damage_dealer: Card, damage: int) -> bool:
	stats.health -= damage
	var has_died := is_dead()
	if is_dead:
		follower_died.emit(self)
	return has_died

## Handles recieving damage in a battle
## @emit If follower dies from this attack
## @return Whether this follower dies from this attack
func recieve_battle_damage(damage_dealers: Array[Follower], damage: int) -> bool:
	stats.health -= damage
	var has_died := is_dead()
	if is_dead:
		follower_died.emit(self)
	return has_died
	

## @param defenders: Must be sorted from lowest health to highest health
## 						ties being broken by highest attack, and then mana cost
##			e.g. defenders[i].recieve_damage([attacker], return[i])
func attack(defenders: Array[Follower]) -> Array[int]:
	return _split_damage_equally(defenders)

## @param attackers: Must be sorted from lowest health to highest health
## 						ties being broken by highest attack, and then mana cost
## @returns how much damage each defender should recieve
##			e.g. attackers[i].recieve_damage([attacker], return[i])
func block(attackers: Array[Follower]) -> Array[int]:
	return _split_damage_equally(attackers)
	
##
## @returns how much influence to attain
func influence() -> int:
	return stats.influence
	
func is_dead() -> bool:
	return stats.health <= 0

## Splits damage across followers, with leftover damage being split across lowest health followers
## @param defenders: Must be sorted from lowest health to highest health
## 						ties being broken by highest attack, and then mana cost
func _split_damage_equally(followers: Array[Follower]) -> Array[int]:
	var damage_dealt : Array[int] = []
	damage_dealt.resize(followers.size())
	damage_dealt.fill(0)
	
	var split_damage : int = floor(stats.attack / followers.size())
	var leftover_damage : int = stats.attack % followers.size()
	for i in range(followers.size()):
		damage_dealt[i] += split_damage
		if leftover_damage > 0:
			damage_dealt[i] += 1
			leftover_damage -= 1
		
	return damage_dealt

func _init(p_card_name := "<Card Name>", \
			p_card_text := "<Card Text>", \
			p_follower_stats : FollowerStats = null) -> void:
	card_name = p_card_name
	card_text = p_card_text
	
	if p_follower_stats == null:
		stats = FollowerStats.new()
	else:
		stats = p_follower_stats
