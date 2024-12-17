extends Node

var TABLE_NAMES = ["Inventory", "Item", "Weapon", "Armor", "Food", "Potion", "Trinket"]
var INFO_TABLE_NAMES = ["Weapon", "Armor", "Food", "Potion", "Trinket"]
var DB_PATH = "./inventory.db"

var default_items = [
	# Name, Type, Value, Weight, StackSize, <Type Specific>
	["Bronze Sword", "Weapon", 10.00, 3.5, 1, 5.0],
	["Bronze Helmet", "Armor", 10.00, 4.0, 1, 5.0],
	["Bronze Chestplate", "Armor", 25.00, 10.0, 1, 12.5],
	["Bronze Platelegs", "Armor", 20.00, 8.0, 1, 10.0],
	["Bronze Sabatons", "Armor", 7.50, 3.0, 1, 3.75],
	["Bronze Gauntlets", "Armor", 7.50, 3.0, 1, 3.75],
	["Bread", "Food", 0.50, 0.5, 99, 10.0, 10.0],
	["Steak", "Food", 5.00, 1.0, 99, 50.0, 25.0],
	["Health Potion", "Potion", 20.00, 1.0, 99, "Regeneration", 60.0],
	["Strength Amulet", "Trinket", 100.00, 1.0, 99, "Strength"],
	["Notes", "Junk", 0.01, 0.01, 99],
]

var _script_strings: Dictionary = {
	"Weapon": Weapon,
	"Armor": Armor,
	"Food": Food,
	"Potion": Potion,
	"Trinket": Trinket,
	"Junk": Junk,
	"Misc.": Miscellaneous,
}

var db: SQLite
var items: Array[Item] = []


func _ready() -> void:
	initialize_db()


func _exit_tree() -> void:
	db.close_db()


func initialize_db() -> void:
	if not FileAccess.file_exists(DB_PATH):
		var db_file: FileAccess = FileAccess.open(DB_PATH, FileAccess.WRITE)
		db_file.close()
	
	db = SQLite.new()
	db.path = DB_PATH
	db.foreign_keys = true
	db.open_db()
	
	#drop_tables()
	
	db.query("SELECT name FROM sqlite_master WHERE type=\"table\" AND name=\"Item\"")
	if db.query_result.size() == 0:
		reset_db()
	else:
		db.query("SELECT * FROM Item")
		var result: Array[Dictionary] = db.query_result
		for row in result:
			var item_instance: Item = create_item_from_item_query(row)
			item_instance.insert_into_db(true)


func reset_db() -> void:
	drop_tables()
	create_tables()
	items = []
	Item._current_id = 0
	
	for item in default_items:
		var item_instance: Item = create_item_from_array(item)
		item_instance.insert_into_db()


func create_item_from_array(item: Array[Variant]) -> Item:
	var item_script: Script = string_to_script(item[1])
	var item_name: String = item[0]
	var item_callable: Callable = item_script.new.bindv(item.slice(2))
	var item_instance: Item = item_callable.call(item_name)
	return item_instance


func create_item_from_item_query(item: Dictionary) -> Item:
	var item_script: Script = string_to_script(item.Type)
	var item_callable: Callable = item_script.new
	var item_instance: Item
	var special_attributes: Array[Variant] = []
	if item.Type in INFO_TABLE_NAMES:
		db.query("SELECT %s.* FROM %s, Item WHERE %s.ItemID=Item.ID AND Item.ID=%d" % [item.Type, item.Type, item.Type, item.ID])
		if db.query_result.size() == 0:
			reset_db()
			return
		var result = db.query_result[0]
		result.erase("ItemID")
		for value in result.values():
			special_attributes.append(value)
		item_callable = item_callable.bindv(special_attributes)
	item_instance = item_callable.call(item.Name, item.Value, item.Weight, item.StackSize)
	return item_instance


func drop_tables() -> void:
	for table_name in TABLE_NAMES:
		db.query("DROP TABLE IF EXISTS %s;" % table_name)


func create_tables() -> void:
	for table_name in TABLE_NAMES:
		db.query("CREATE TABLE %s (%s);" % [table_name, Schemata.get_schema(table_name)])


func delete_item(item: Item) -> void:
	db.delete_rows("Item", "id=%d" % item.id) # ON DELETE CASCADE
	#if item.type in INFO_TABLE_NAMES:
		#db.delete_rows(item.type, "ItemId=%d" % item.id)
	if item.id == Item._current_id:
		Item._current_id = items[-2].id
	items.erase(item)


func string_to_script(script_name: String) -> Script:
	if script_name in _script_strings:
		return _script_strings[script_name]
	return Item
