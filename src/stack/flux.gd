class_name Flux
extends Resource
## Immutable Type representing flux

static var DICT_TYPE := "flux"
## Underlying data structure of Flux[br]
## Dictionary[FluxType, int]
@export var _flux: Dictionary = {}

func _init() -> void:
	_flux["dict_type"] = DICT_TYPE
	for type: Enums.FluxType in Enums.FluxType.values():
		_flux[type] = 0

	_flux.make_read_only()

## Producer method
func add(other_flux: Flux) -> Flux:
	var new_flux = Flux.new()

	for type: Enums.FluxType in Enums.FluxType.values():
		new_flux._flux[type] += other_flux._flux[type]

	return new_flux

## Observer method[br]
## [param param flux_payment] Flux to use to pay for other flux[br]
## [param return] Option<Flux> If you were able to pay for it, returns remaining flux
func pay_cost(flux_payment: Flux) -> Option:
	var flux : Flux = self.duplicate()
	for type: Enums.FluxType in Enums.FluxType.values():
		var cost := flux.flux(type)
		var payment := flux_payment.flux(type)
		if cost > payment:
			return Option.None()

		flux._flux[type] -= payment

	return Option.Some(flux)

## Observer method[br]
## [param return] Returns how much flux of specified type you have
func flux(flux_type: Enums.FluxType) -> int:
	return _flux[flux_type]

## Observer method
func to_dict() -> Dictionary:
	return _flux.duplicate()

## Creator method
static func from_dict(flux_dict: Dictionary) -> Flux:
	assert(flux_dict["dict_type"] == DICT_TYPE)
	var flux := Flux.new()
	flux._flux = flux_dict.duplicate()
	return flux