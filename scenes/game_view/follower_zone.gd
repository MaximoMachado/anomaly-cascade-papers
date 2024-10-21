extends Area2D

@export var size := Vector2(1000, 400) :
	get: return $CollisionShape.shape.size
	set(value): $CollisionShape.shape.size = value

@export var CARD_MARGIN := Vector2(0, 0)
var selected_follower: FollowerView = null

func _ready() -> void:
	draw()

func draw():
	var followers := get_children().filter(func(child): return child is FollowerView)
	for i in followers.size():
		var follower = followers[i]	
		follower.starting_position = Vector2(follower.size.x * i, 0) + CARD_MARGIN
		follower.position = follower.starting_position
		follower.draw()
		
func remove_card(card: CardView):
	if card == selected_follower:
		selected_follower = null
	remove_child(card)


func _on_child_entered_tree(node: Node) -> void:
	if node is CardView:
		node.hoverable = true
		node.select_requested.connect(_on_follower_select_requested)
		node.deselect_requested.connect(_on_follower_deselect_requested)
		draw()


func _on_child_exiting_tree(node: Node) -> void:
	if node is CardView:
		node.select_requested.disconnect(_on_follower_select_requested)
		node.deselect_requested.disconnect(_on_follower_deselect_requested)
		draw()


func _on_follower_select_requested(follower: FollowerView):
	if selected_follower != null:
		selected_follower.deselect()
	selected_follower = follower
	selected_follower.select()

func _on_follower_deselect_requested(follower: FollowerView):
	if selected_follower == follower:
		selected_follower.deselect()
		selected_follower = null
