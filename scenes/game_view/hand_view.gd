extends Area2D

func _ready() -> void:
	for child in get_children():
		if child is CardView:
			child.on_selected.connect(_on_card_selected)


func _on_card_hovered(hovered_card: CardView) -> void:
	pass
	
func _on_card_selected(hovered_card: CardView) -> void:
	hovered_card.on_deselected.connect(_on_card_deselected)
	hovered_card.reparent(get_parent())
	
	for child in get_children():
		if child is CardView:
			child.input_active = false

func _on_card_deselected(deselected_card: CardView) -> void:
	deselected_card.reparent(self, false)
	deselected_card.on_deselected.disconnect(_on_card_deselected)
	for child in get_children():
		if child is CardView:
			child.input_active = true
