extends PanelContainer

@onready var inventory_level: InventoryLevel = $PlayerInventoryContainer/InventoryLevel
@onready var inventory_storage: InventoryLevel = $StorageContainer/InventoryStorage

func _ready() -> void:
	inventory_level.set_inventory(inventory_level.inventoryData)
	inventory_storage.set_inventory(inventory_storage.inventoryData)


func _on_inventory_storage_item_got(item: InvItem) -> void:
	inventory_level.inv.insert(item)
