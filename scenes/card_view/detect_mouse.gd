@tool
extends Control

func _on_resized() -> void:
	$Background.size = size
	$VBoxContainer.size = size
