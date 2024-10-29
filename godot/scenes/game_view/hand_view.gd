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
	var cards : Array[CardView] = []
	cards.assign(get_children().filter(func(child: Node) -> bool: return child is CardView))
	for i in cards.size():
		var card := cards[i]	
		card.starting_position = Vector2(card.size.x * i, 0) + CARD_MARGIN
		card.position = card.starting_position
		card.draw.call_deferred()


func _on_child_entered_tree(node: Node) -> void:
	if node is CardView:
		var card : CardView = node
		card.hoverable = true
		card.select_requested.connect(_on_card_select_requested)
		card.deselect_requested.connect(_on_card_deselect_requested)
		draw.call_deferred()


func _on_child_exiting_tree(node: Node) -> void:
	if node is CardView:
		var card : CardView = node
		if selected_card.matches(node):
			selected_card = Option.None()
		card.select_requested.disconnect(_on_card_select_requested)
		card.deselect_requested.disconnect(_on_card_deselect_requested)
		draw.call_deferred()


func _on_card_select_requested(card: CardView):
	if selected_card.is_some():
		selected_card.unwrap().deselect()
	selected_card = Option.Some(card) \
						.map_mut(func(value: CardView) -> void: value.select())

func _on_card_deselect_requested(card: CardView):
	if selected_card.matches(card):
		selected_card.unwrap().deselect()
		selected_card = Option.None()
