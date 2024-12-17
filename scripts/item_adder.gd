class_name ItemAdder
extends Control


var attribute_edit_container: PackedScene = preload("res://scenes/attribute_edit_container.tscn")
var item_scripts: Array[Script] = [Armor, Food, Junk, Miscellaneous, Potion, Trinket, Weapon]
var item_type_names: Array[String] = ["Armor", "Food", "Junk", "Misc.", "Potion", "Trinket", "Weapon"]
var item_to_add: Item
var display_attributes: Dictionary

@onready var db_interface: DBInterface = get_parent()
@onready var attributes_container: VBoxContainer = %AttributesContainer
@onready var type_dropdown: OptionButton = %TypeDropdown
@onready var add_button: Button = %AddButton
@onready var back_button: Button = %BackButton


func _ready() -> void:
	type_dropdown.item_selected.connect(_on_dropdown_selected)
	add_button.pressed.connect(_on_add_item_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	update_item_type()


func update_item_type() -> void:
	for container in attributes_container.get_children():
		if container == type_dropdown.get_parent():
			continue
		container.free()
	var item_script: Script = item_scripts[type_dropdown.get_selected_id()]
	item_to_add = item_script.new()
	display_attributes = item_to_add.get_display_attributes()
	for display_name in display_attributes:
		var attribute_name: String = display_name.to_snake_case()
		var attribute_value: Variant = item_to_add.get(attribute_name)
		if attribute_name == "type":
			continue
		var container: AttributeEditContainer = attribute_edit_container.instantiate()
		container.type_hint = type_string(typeof(attribute_value))
		container.attribute_name = display_name
		container.value_changed.connect(update_item_attribute)
		attributes_container.add_child(container)


func reset_form() -> void:
	type_dropdown.select(3)
	update_item_type()


func update_item_attribute(attribute_name: String, attribute_value: Variant) -> void:
	item_to_add.set(attribute_name.to_snake_case(), attribute_value)


func _on_dropdown_selected(_index: int) -> void:
	update_item_type()


func _on_add_item_pressed() -> void:
	item_to_add.type = item_type_names[type_dropdown.get_selected_id()]
	item_to_add.insert_into_db()
	db_interface.add_item_button(item_to_add)
	reset_form()
	hide()


func _on_back_button_pressed() -> void:
	reset_form()
	hide()
