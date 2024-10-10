class_name CardView extends Node2D

@export var card: Card
var card_highlighted: bool = false

static func new_card_view(card_state: Card) -> CardView:
	var card_view: CardView = load("res://scenes/card_view/card_view.tscn").instantiate()
	card_view.card = card_state
	return card_view

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var container := $DetectMouse
	var card_front := $Image
	var card_front_size : Vector2 = card_front.texture.get_size()
	container.custom_minimum_size = Vector2(card_front_size.x / card_front.hframes, \
									card_front_size.y / card_front.vframes)
	print_debug(container.custom_minimum_size)
	
	if card is Follower:
		print_debug(" yaya")
		$Health.text = str(card.stats.health)
		$Influence.text = str(card.stats.influence)
		$Attack.text = str(card.stats.attack)
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
