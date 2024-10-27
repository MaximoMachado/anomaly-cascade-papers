extends Area2D

@export var size := Vector2(1000, 400) :
	get: return $CollisionShape.shape.size
	set(value): $CollisionShape.shape.size = value

@export var CARD_MARGIN := Vector2(0, 0)
## Option<CardView>
var selected_card: Option = Option.None()

func _ready() -> void:
	draw()

func draw():
	var cards := get_children().filter(func(child): return child is CardView)
	for i in cards.size():
		var card = cards[i]	
		card.starting_position = Vector2(card.size.x * i, 0) + CARD_MARGIN
		card.position = card.starting_position
		card.draw.call_deferred()


func _on_child_entered_tree(node: Node) -> void:
	if node is CardView:
		node.hoverable = true
		node.select_requested.connect(_on_card_select_requested)
		node.deselect_requested.connect(_on_card_deselect_requested)
		draw.call_deferred()


func _on_child_exiting_tree(node: Node) -> void:
	if node is CardView:
		if selected_card.matches(node):
			selected_card = Option.None()
		node.select_requested.disconnect(_on_card_select_requested)
		node.deselect_requested.disconnect(_on_card_deselect_requested)
		draw.call_deferred()


func _on_card_select_requested(card: CardView):
	if selected_card != null:
		selected_card.deselect()
	selected_card = Option.Some(card)
	selected_card.select()

func _on_card_deselect_requested(card: CardView):
	if selected_card == card:
		selected_card.deselect()
		selected_card = Option.None()
