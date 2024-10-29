## class_name Types <- autoload so commented out
extends Node

## Used for variable setters to signify that this is a read_only variable
## Errors out if it is assigned to
func read_only(old_value: Variant, new_value: Variant) -> Variant:
	if old_value == null:
		return new_value
	else:
		push_error("read_only: invalid assignment on variable")
		assert(false, "read_only: invalid assignment on variable")
		return old_value

func to_dict(object: Object) -> Dictionary:
	if object.has_method("to_dict"):
		return object.to_dict()
	else:
		push_error("Object does not implement to_dict()")
		return {}

## Returns whether Object implements Interface[br]
## An object implements an interface if it has the same public methods, public properties, and signals
func implements(object: Object, interface: Script) -> bool:
	var uses_interfaces : bool = object.get("implements") != null and object.implements != null
	if not uses_interfaces:
		return false

	for method: Dictionary in interface.get_script_method_list():
		var name : String = method["name"]
		if not object.has_method(name):
			return false

	for property: Dictionary in interface.get_script_property_list():
		var name : String = property["name"]
		if not object.has_method(name):
			return false

	for signal_method: Dictionary in interface.get_script_signal_list():
		var name : String = signal_method["name"]
		if not object.has_signal(name):
			return false

	return true
