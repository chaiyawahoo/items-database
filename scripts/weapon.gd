class_name Weapon
extends Item


var attack: float


@warning_ignore("shadowed_variable")
func _init(name: String="New Weapon", value: float=0, weight: float=0, stack_size: int=1, attack: float=0) -> void:
	super._init(name, "Weapon", value, weight, stack_size)
	if attack < 0:
		push_warning("Attack must be no less than 0 (tried to set to %.2f). Setting Attack to 0." % attack)
		attack = 0
	
	self.attack = attack


func insert_into_db(skip_insert: bool=false) -> void:
	super.insert_into_db(skip_insert)
	if skip_insert:
		return
	var row: Dictionary = {
		"ItemID": self.id,
		"Attack": self.attack,
	}
	
	DBHandler.db.insert_row("Weapon", row)


func get_display_attributes() -> Dictionary:
	var output: Dictionary = super.get_display_attributes()
	return output.merged({
		"Attack": "%.2f damage" % attack,
	})


func _to_string() -> String:
	return "(%d, %s, %s, %.2f, %.2f, %d, %.2f)" % [self.id, self.name, self.type, self.value, self.weight, self.stack_size, self.attack]
