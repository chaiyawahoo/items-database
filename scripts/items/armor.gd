class_name Armor
extends Item


var defense: float


@warning_ignore("shadowed_variable")
func _init(name: String="New Armor", value: float=0, weight: float=0, stack_size: int=1, defense: float=0) -> void:
	super._init(name, "Armor", value, weight, stack_size)
	if defense < 0:
		push_warning("Defense must be no less than 0 (tried to set to %.2f). Setting Defense to 0." % defense)
		defense = 0
	
	self.defense = defense


func insert_into_db(skip_insert: bool=false) -> void:
	super.insert_into_db(skip_insert)
	if skip_insert:
		return
	var row = {
		"ItemID": self.id,
		"Defense": self.defense,
	}
	
	DBHandler.db.insert_row("Armor", row)


func get_display_attributes() -> Dictionary:
	var output: Dictionary = super.get_display_attributes()
	return output.merged({
		"Defense": "%.2f armor" % defense
	})


func _to_string() -> String:
	return "(%d, %s, %s, %.2f, %.2f, %d, %.2f)" % [self.id, self.name, self.type, self.value, self.weight, self.stack_size, self.defense]
