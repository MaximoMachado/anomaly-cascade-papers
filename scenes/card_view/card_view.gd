class_name CardView extends Node2D

@export var card: Card
var card_highlighted: bool = false

func _init(p_card: Card) -> void:
	card = p_card

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if card is Follower:
		$Health.text = str(card.stats.health)
		$Influence.text = str(card.stats.influence)
		$Attack.text = str(card.stats.attack)

		var card_image := $Image
		if card.card_image != null:
			card_image.texture = card.card_image
	else:
		print_debug("nono")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_container_mouse_entered() -> void:
	$AnimationPlayer.play("Select")
	card_highlighted = true


func _on_container_mouse_exited() -> void:
	$AnimationPlayer.play("Deselect")
	card_highlighted = false
