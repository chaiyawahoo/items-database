class_name DBInterface
extends Control


var attribute_container: PackedScene = preload("res://scenes/attribute_container.tscn")
var item_name_format := "[center][u]%s[/u][/center]"
var current_item: Item

@onready var item_list: VBoxContainer = %ItemList
@onready var new_button: Button = %NewButton
@onready var reset_button: Button = %ResetButton
@onready var inspect_item_name: RichTextLabel = %ItemName
@onready var attribute_list: VBoxContainer = %AttributeList
@onready var delete_button: Button = %DeleteButton
@onready var item_adder: ItemAdder = %ItemAdder
@onready var item_list_button_group := ButtonGroup.new()


func _ready() -> void:
	item_list_button_group.allow_unpress = true
	delete_button.pressed.connect(_on_item_delete)
	new_button.pressed.connect(_on_new_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)
	refresh_items()


func refresh_items() -> void:
	for button in item_list.get_children():
		button.free()
	for item in DBHandler.items:
		add_item_button(item)


func add_item_button(item: Item) -> void:
	var button := Button.new()
	button.toggle_mode = true
	button.button_group = item_list_button_group
	button.text = item.name
	button.toggled.connect(_on_item_toggled.bind(item))
	item_list.add_child(button)


func _on_item_toggled(toggled_on: bool, item: Item) -> void:
	if toggled_on:
		_on_item_selected(item)
	else:
		_on_item_deselected()


func _on_item_selected(item: Item) -> void:
	inspect_item_name.text = item_name_format % item.name
	var display_attributes := item.get_display_attributes()
	display_attributes.erase("Name")
	for attribute in display_attributes:
		var container: AttributeContainer = attribute_container.instantiate()
		container.attribute_name = attribute
		container.attribute_value = display_attributes[attribute]
		attribute_list.add_child(container)
	delete_button.show()
	current_item = item


func _on_item_deselected() -> void:
	inspect_item_name.text = ""
	for node in attribute_list.get_children():
		node.free()
	delete_button.hide()
	current_item = null


func _on_item_delete() -> void:
	if current_item:
		DBHandler.delete_item(current_item)
		item_list_button_group.get_pressed_button().free()
		_on_item_deselected()


func _on_new_button_pressed() -> void:
	item_adder.show()


func _on_reset_button_pressed() -> void:
	DBHandler.reset_db()
	refresh_items()
