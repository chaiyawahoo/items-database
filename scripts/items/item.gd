class_name Item
extends RefCounted


static var _current_id: int = 0
var _types: Array[String] = ["Weapon", "Armor", "Food", "Potion", "Trinket", "Junk", "Misc."]

var id: int
var name: String
var type: String
var value: float
var weight: float
var stack_size: int


@warning_ignore("shadowed_variable")
func _init(name: String="New Item", type: String="Misc.", value: float=0, weight: float=0, stack_size: int=1) -> void:
	if not type in _types:
		push_warning("Item %s not created. Type %s is invalid." % [name, type])
		return
	if value < 0:
		push_warning("Value must be no less than 0 (tried to set to %.2f). Setting Value to 0." % value)
		value = 0
	if weight < 0:
		push_warning("Weight must be no less than 0 (tried to set to %.2f). Setting Weight to 0." % weight)
		weight = 0
	if stack_size <= 0:
		push_warning("Stack Size must be greater than 0 (tried to set to %d). Setting Stack Size to 1." % stack_size)
		stack_size = 1
	
	self.name = name
	self.type = type
	self.value = value
	self.weight = weight
	self.stack_size = stack_size


func insert_into_db(skip_insert: bool=false) -> void:
	self.id = _next_id()
	DBHandler.items.append(self)
	if skip_insert:
		return
	var row: Dictionary = {
		"Name": name,
		"Type": type,
		"Value": value,
		"Weight": weight,
		"StackSize": stack_size,
	}
	
	DBHandler.db.insert_row("Item", row)


func get_display_attributes() -> Dictionary:
	return {
		"Name": name,
		"Type": type,
		"Value": "%.2f crowns" % value,
		"Weight": "%.2f lbs." % weight,
		"Stack Size": str(stack_size),
	}


func _to_string() -> String:
	return "(%d, %s, %s, %.2f, %.2f, %d)" % [self.id, self.name, self.type, self.value, self.weight, self.stack_size]


func _next_id() -> int:
	_current_id += 1
	return _current_id
