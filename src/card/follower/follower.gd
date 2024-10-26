class_name Follower extends Card
## Represents the follower card type, equivalent to Hearthstone's Minion type
## When played from hand, it is summoned onto the board on player's side

# Used for to_dict/from_dict for dynamic dispatch
static var DICT_TYPE := "follower"

signal follower_died(follower: Follower)

var stats: FollowerStats = FollowerStats.new()

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

##
## @return Whether this follower dies from this stat change
func add_stats(attack: int, influence: int, health: int) -> bool:
	stats.attack += attack
	stats.influence += influence
	stats.max_health += health

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

## Producers

func to_dict() -> Dictionary:
	var follower_dict := {}
	follower_dict["dict_type"] = DICT_TYPE
	follower_dict["card_image_path"] = card_image_path
	follower_dict["card_name"] = card_name
	follower_dict["card_text"] = card_text
	follower_dict["flux"] = flux.to_dict()
	follower_dict["stats"] = stats.to_dict()

	return follower_dict

static func from_dict(follower_dict: Dictionary) -> Follower:
	assert(follower_dict["dict_type"] == DICT_TYPE)

	var follower := Follower.new()
	follower.card_image_path = follower_dict["card_image_path"]
	follower.card_name = follower_dict["card_name"]
	follower.card_text = follower_dict["card_text"]
	follower.flux = Flux.from_dict(follower_dict["flux"])
	follower.stats = FollowerStats.from_dict(follower_dict["stats"])

	return follower

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
