class_name Battle extends RefCounted

var attackers: Array[Follower] = []
var blocker: Array[Follower] = []


func _init() -> void:
    attackers = []
    blocker = []

func attacker(follower: Follower):
    attacker.append(follower)

func blocker(follower: Follower):
    blocker.append(follower)

## Mutates attacking and defending followers 
func resolve_damage() -> void:
    var damage_dealt_to_defenders: Array[int] = []
    damage_dealt_to_defenders.resize(blocker.size())
    damage_dealt_to_defenders.fill(0)

    for i in range(attackers.size()):
        var attacker := attackers[i]
        var damage_dealt := attacker.attack(blocker)
        for j in range(damage_dealt.size()):
            damage_dealt_to_defenders[j] += damage_dealt[j]
        

    var damage_dealt_to_attackers: Array[int] = []
    damage_dealt_to_attackers.resize(attackers.size())
    damage_dealt_to_attackers.fill(0)

    for i in range(blocker.size()):
        var defender := blocker[i]
        var damage_dealt := defender.block(attackers)
        for j in range(damage_dealt.size()):
            damage_dealt_to_attackers[j] += damage_dealt[j]

    # Update health of attackers/blocker
    for i in range(attackers.size()):
        attackers[i].recieve_battle_damage(blocker, damage_dealt_to_attackers[i])

    for i in range(blocker.size()):
        blocker[i].recieve_battle_damage(attackers, damage_dealt_to_defenders[i])