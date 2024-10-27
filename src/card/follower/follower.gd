class_name Follower extends Card
## Represents the Follower card type, equivalent to Hearthstone's Minion type
##
## Class handles both when a Follower is in the player's hand and when it is played out onto the Battlefield.
## As such, Follower has an interface that defines actions that can be taken on the battlefield such as attacking, blocking, and influencing.

## Used for to_dict/from_dict for dynamic dispatch
static var DICT_TYPE := "follower"

## Emitted when this follower dies[br]
## [param param follower] Follower that died
signal follower_died(follower: Follower)

## The stats unique to a Follower card when on the battlefield
@export var stats: FollowerStats = FollowerStats.new()

## Mutator method[br]
## Recieve damage from any [Card] [br]
## [param return] If this follower dies from the damage
func recieve_damage(damage_dealer: Card, damage: int) -> bool:
	stats.health -= damage
	var has_died := is_dead()
	if is_dead:
		follower_died.emit(self)
	return has_died

## Mutator method[br]
## Recieve damage in a battle[br]
## [param param damage_dealers] Combatants dealing damage[br]
## [param param damage] Total damage to recieve[br]
## [param return] If this follower dies from this attack
func recieve_battle_damage(damage_dealers: Array[Follower], damage: int) -> bool:
	stats.health -= damage
	var has_died := is_dead()
	if is_dead:
		follower_died.emit(self)
	return has_died

## Mutator method[br]
## Mutates follower's stats with +[param attack] / +[param influence] / +[param health][br]
## [param return] If this follower dies from this attack
func add_stats(attack: int, influence: int, health: int) -> bool:
	stats.attack += attack
	stats.influence += influence
	stats.max_health += health

	var has_died := is_dead()
	if is_dead:
		follower_died.emit(self)
	return has_died
	

## Observer Method[br]
## Deals damage to defenders.[br]
## [param param defenders] Array must be sorted from lowest health to highest health[br]
## 						Remainder damage is dealt to those earlier in array[br]
##						[code]e.g. defenders[i].recieve_damage([attacker], return[i])[/code][br]
## [param return] [code]defender i is assigned damage equal to return[i][/code]
func attack(defenders: Array[Follower]) -> Array[int]:
	return _split_damage_equally(defenders)

## Observer Method[br]
## Deals damage to attackers.[br]
## @param attackers: Must be sorted from lowest health to highest health[br]
## 						Remainder damage is dealt to those earlier in array[br]
##						[code]e.g. attackers[i].recieve_damage([defender], return[i])[/code][br]
## [param return] [code]attacker i is assigned damage equal to return[i][/code]
func block(attackers: Array[Follower]) -> Array[int]:
	return _split_damage_equally(attackers)
	
## Observer method[br]
## [param return] How much influence to attain
func influence() -> int:
	return stats.influence
	
## Observer method[br]
## [param return] Whether or not this follower is dead
func is_dead() -> bool:
	return stats.health <= 0

## Observer method[br]
## [param return] Returns dictionary representation
func to_dict() -> Dictionary:
	var follower_dict := {}
	follower_dict["dict_type"] = DICT_TYPE
	follower_dict["card_image_path"] = card_image_path
	follower_dict["card_name"] = card_name
	follower_dict["card_text"] = card_text
	follower_dict["flux"] = flux.to_dict()
	follower_dict["stats"] = stats.to_dict()

	return follower_dict

## Creator method[br]
## [param return] Returns dictionary representation
static func from_dict(follower_dict: Dictionary) -> Follower:
	assert(follower_dict["dict_type"] == DICT_TYPE)

	var follower := Follower.new()
	follower.card_image_path = follower_dict["card_image_path"]
	follower.card_name = follower_dict["card_name"]
	follower.card_text = follower_dict["card_text"]
	follower.flux = Flux.from_dict(follower_dict["flux"])
	follower.stats = FollowerStats.from_dict(follower_dict["stats"])

	return follower

## Observer method[br]
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

func _init(p_card_name : String = "<Card Name>", \
			p_card_text : String = "<Card Text>", \
			p_follower_stats : FollowerStats = null) -> void:
	card_name = p_card_name
	card_text = p_card_text
	
	if p_follower_stats == null:
		stats = FollowerStats.new()
	else:
		stats = p_follower_stats.duplicate()
