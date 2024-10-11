class_name FluxCost
extends RefCounted

var _flux: Dictionary

func _init() -> void:
    for type: Enums.FluxType in Enums.FluxType.values():
        _flux[type] = 0


func add_flux(flux: Enums.FluxType) -> void:
    _flux[flux] += 1