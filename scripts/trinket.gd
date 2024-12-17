class_name Trinket
extends Item


var effect: String


@warning_ignore("shadowed_variable")
func _init(name: String="New Trinket", value: float=0, weight: float=0, stack_size: int=1, effect: String="Random Effect") -> void:
	super._init(name, "Trinket", value, weight, stack_size)
	
	self.effect = effect


func insert_into_db(skip_insert: bool=false) -> void:
	super.insert_into_db(skip_insert)
	if skip_insert:
		return
	var row: Dictionary = {
		"ItemID": self.id,
		"Effect": self.effect
	}
	
	DBHandler.db.insert_row("Trinket", row)


func get_display_attributes() -> Dictionary:
	var output: Dictionary = super.get_display_attributes()
	return output.merged({
		"Effect": effect
	})


func _to_string() -> String:
	return "(%d, %s, %s, %.2f, %.2f, %d, %s)" % [self.id, self.name, self.type, self.value, self.weight, self.stack_size, self.effect]
