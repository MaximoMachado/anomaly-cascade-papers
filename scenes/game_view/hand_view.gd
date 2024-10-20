extends Area2D

@export var CARD_MARGIN := Vector2(0, 0)
var selected_card: CardView = null

func _ready() -> void:
	draw()

func draw():
	var cards := get_children().filter(func(child): return child is CardView)
	for i in cards.size():
		var card = cards[i]	
		card.starting_position = Vector2(card.size.x * i, 0) + CARD_MARGIN
		card.position = card.starting_position
		card.draw()

func _on_child_entered_tree(node: Node) -> void:
	if node is CardView:
		node.hoverable = true
		node.select_requested.connect(_on_card_select_requested)
		node.deselect_requested.connect(_on_card_deselect_requested)
		draw()


func _on_child_exiting_tree(node: Node) -> void:
	if node is CardView:
		node.select_requested.disconnect(_on_card_select_requested)
		node.deselect_requested.disconnect(_on_card_deselect_requested)
		draw()


func _on_card_select_requested(card: CardView):
	if selected_card != null:
		selected_card.deselect()
	selected_card = card
	selected_card.select()

func _on_card_deselect_requested(card: CardView):
	if selected_card == card:
		selected_card.deselect()
		selected_card = null
