extends Node


var inventory_schema: String = \
"""
	SlotID INTEGER NOT NULL,
	ItemID INTEGER,
	Count INTEGER,
	PRIMARY KEY (SlotID)
	FOREIGN KEY (ItemID) REFERENCES Item(ID) ON DELETE CASCADE,
	CHECK (Count >= 0)
"""

var item_schema: String = \
"""
	ID INTEGER NOT NULL,
	Name TEXT,
	Type TEXT,
	Value REAL,
	Weight REAL,
	StackSize INTEGER,
	PRIMARY KEY (ID),
	CHECK (Value >= 0 AND Weight >= 0 AND StackSize > 0)
"""

var weapon_schema: String = \
"""
	ItemID INTEGER NOT NULL,
	Attack REAL,
	PRIMARY KEY (ItemID),
	FOREIGN KEY (ItemID) REFERENCES Item(ID) ON DELETE CASCADE
"""

var armor_schema: String = \
"""
	ItemID INTEGER NOT NULL,
	Defense REAL,
	PRIMARY KEY (ItemID),
	FOREIGN KEY (ItemID) REFERENCES Item(ID) ON DELETE CASCADE
"""

var food_schema: String = \
"""
	ItemID INTEGER NOT NULL,
	HealthRestore REAL,
	StaminaRestore REAL,
	PRIMARY KEY (ItemID),
	FOREIGN KEY (ItemID) REFERENCES Item(ID) ON DELETE CASCADE
"""

var potion_schema: String = \
"""
	ItemID INTEGER NOT NULL,
	Effect TEXT,
	Duration REAL,
	PRIMARY KEY (ItemID),
	FOREIGN KEY (ItemID) REFERENCES Item(ID) ON DELETE CASCADE
"""

var trinket_schema: String = \
"""
	ItemID INTEGER NOT NULL,
	Effect TEXT,
	PRIMARY KEY (ItemID),
	FOREIGN KEY (ItemID) REFERENCES Item(ID) ON DELETE CASCADE
"""

var schemata: Dictionary = {
	"Inventory": inventory_schema,
	"Item": item_schema,
	"Weapon": weapon_schema,
	"Armor": armor_schema,
	"Food": food_schema,
	"Potion": potion_schema,
	"Trinket": trinket_schema
}


func get_schema(schema_name: String) -> String:
	if schema_name not in schemata:
		push_warning("Schema for %s does not exist." % schema_name)
		return ""
	return schemata[schema_name]
