extends Area3D


@export var stored_items = {"fancy_book" : 75, "old_book" : 38}




func add_item(name : String, price : int):
	assert (!stored_items.has(name))
	stored_items[name] = price
	pass
	


func remove_item(name : String):
	assert (stored_items.has(name))
	stored_items.erase(name)
	pass
