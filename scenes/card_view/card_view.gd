class_name CardView extends Node2D

@export var card: Card
var startPosition: Vector2
var card_highlighted: bool = false

static func new_card_view(card_state: Card, position: Vector2) -> CardView:
	var card_view: CardView = load("res://scenes/card_view/card_view.tscn").instantiate()
	card_view.card = card_state
	card_view.startPosition = position
	return card_view

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var container := $DetectMouse
	var card_front := $CardTemplate
	var card_front_size : Vector2 = card_front.texture.get_size()
	container.custom_minimum_size = Vector2(card_front_size.x / card_front.hframes, \
									card_front_size.y / card_front.vframes)
	print(container.custom_minimum_size)
	
	if card is Follower:
		print(" yaya")
		$Health.text = str(card.stats.health)
		$Influence.text = str(card.stats.influence)
		$Attack.text = str(card.stats.attack)
	else:
		print("nono")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_container_mouse_entered() -> void:
	$AnimationPlayer.play("Select")
	card_highlighted = true


func _on_container_mouse_exited() -> void:
	$AnimationPlayer.play("Deselect")
	card_highlighted = false
