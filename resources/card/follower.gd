class_name Follower extends Card
## Represents the follower card type, equivalent to Hearthstone's Minion type
## When played from hand, it is summoned onto the board on player's side

@export var follower_stats: FollowerStats

func play() -> void:
	super()

func _init(p_card_name = "<Card Name>", \
			p_card_text = "<Card Text>", \
			p_follower_stats = null):
	card_name = p_card_name
	card_text = p_card_text
	
	if p_follower_stats == null:
		follower_stats = FollowerStats.new()
	else:
		follower_stats = p_follower_stats
