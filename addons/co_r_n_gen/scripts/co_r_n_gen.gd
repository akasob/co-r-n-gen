@icon("res://addons/co_r_n_gen/icons/co_r_n_gen_w.svg") # for dark themes
#@icon("res://addons/co_r_n_gen/icons/co_r_n_gen_b.svg") # for light themes

## Convenient random number generator with handy methods.
class_name CoRNGen extends RandomNumberGenerator


## Service function for untyped version of shuffle().
## Can to be called separately by users to measure arrays.
func can_hold_types(array: Array) -> bool:
	var counts := func(accum: Dictionary, item) -> Dictionary:
		accum[typeof(item)] = accum.get_or_add(typeof(item), 0) + 1
		return accum
	var criteria := func(accum: bool, item) -> bool:
		return accum and item > 1
	return array.reduce(counts, {}).values().reduce(criteria, true)


## Calculates rate of success for 'what' out 'of'.
func chance(what: int, of: int = 10) -> bool:
	if what <= 0 or of <= 0:
		return false
	return self.randi() % of < what


## Guaranteed number of success ('what'), written in array (which size is 'of').
func chance_table(what: int, of: int = 10) -> Array[bool]:
	if of <= 0:
		return []
	
	var result : Array[bool] = []
	if result.resize(of) != OK:
		return []
	
	if what <= 0:
		return result
	elif what >= of:
		result.fill(true)
		return result
	
	for iteration in what:
		var index := self.randi() % of
		while result[index]: # Searching 'false' ...
			index = wrapi(index + self.randi() % of, 0,  of - 1)
		result[index] = true # ...and make it 'true'
	
	return result


## Floating-point version of chance function.
func chancef(what: float, of: float = 1.0) -> bool:
	if what <= 0 or of <= 0:
		return false
	return self.randf_range(0, of) < what


## Flips up a virtual coin, wraps randbool into string names.
func coin(heads: StringName = &"heads", tails: StringName = &"tails") -> StringName:
	return heads if randbool() else tails


## Performs a certain number of dice rolls with given parameters.
func dice(amount: int = 1, dimension: int = 6, bonus: int = -0) -> int:
	if amount < 1:
		return bonus
	if dimension == 1:
		return amount + bonus
	elif dimension < 1:
		return 0
	
	var result :=0
	
	for n in amount:
		result += self.randi_range(1, dimension)
	
	return result + bonus


## Randomly doing an action from callback or not.
func do_or_not(what: Callable) -> void:
	if randbool():
		what.call()


## Randomly doing an action from callback or not, using chances.
func do_or_not_with_chance(what: Callable, with: int = 1, of: int = 2) -> void:
	# Default chance 1 of 2 identical to randbool().
	if chance(with, of):
		what.call()


## Reimplementation of engine function within generator instance with full access to seed and state.
## Returns the element of the array at random index.
func pick_random(from: Array) -> Variant:
	var e := "Trying to pick value from empty array!"
	return push_error.call(e) if !from else from[self.randi() % from.size()]


## Reimplementation of engine function within generator instance with full access to seed and state.
## Removes and returns the element of the array at random index.
func pop_random(from: Array) -> Variant:
	var e := "Truing to extract value from empty array!"
	return push_error.call(e) if !from else from.pop_at(self.randi() % from.size())


## Random boolean for convenience.
func randbool() -> bool:
	return bool(self.randi_range(0, 1))


## Randomly returning a value from callback or fallback.
func return_or_not(what: Callable, fallback: Variant = null) -> Variant:
	if randbool():
		var result = what.call()
		return fallback if result == null else result
	else:
		return fallback


## Randomly returning a value from callback or fallback, using chances.
func return_or_not_with_chance(what: Callable, fallback: Variant = null, with: int = 1, of: int = 2) -> Variant:
	if chance(with, of):
		var result = what.call()
		return fallback if result == null else result
	else:
		return fallback


## Hard version of shuffle method. Looks more professional if you stared.
func riffle(array: Array) -> Array:
	if array.size() == 2: 
		if randbool():
			array.reverse()
	elif array.size() > 2:
		var slifir := array.slice(0, floori(array.size() / 2.0))
		var slisec := array.slice(floori(array.size() / 2.0), array.size())
		array.clear()
		while slifir or slisec:
			if randbool():
				if slifir:
					array.append(slifir.pop_back())
			else:
				if slisec:
					array.append(slisec.pop_back())
	return array


## Reimplementation of engine function within generator instance.
## Don't disable type mixing if array hasn't at least 2 items of each type, 
## because in that case type mixing to be auto-enabled and you get UB.
func shuffle(array: Array, type_mixing := true) -> Array:
	if not type_mixing:
		type_mixing = not can_hold_types(array)
		if type_mixing:
			push_error("type mixing was re-enabled")
	if array.size() == 2: 
		if randbool():
			array.reverse()
	elif array.size() > 2:
		var tmp # Variant
		var j: int
		for i in range(array.size()-1, -1, -1):
			j = self.randi() % array.size()
			while j == i if type_mixing else j == i or typeof(array[i]) != typeof(array[j]): 
				j = self.randi() % array.size()
			tmp = array[i]
			array[i] = array[j]
			array[j] = tmp
	return array


## Boolean version of shuffle function.
func shuffleb(array: Array[bool]) -> Array[bool]:
	return Array(shuffle(array), TYPE_BOOL, &"", null)

## Floating-point version of shuffle function.
func shufflef(array: Array[float]) -> Array[float]:
	return Array(shuffle(array), TYPE_FLOAT, &"", null)

## Integer version of shuffle function.
func shufflei(array: Array[int]) -> Array[int]:
	return Array(shuffle(array), TYPE_INT, &"", null)

## Packed Int32 version of shuffle function.
func shuffleip(array: PackedInt32Array) -> PackedInt32Array:
	return Array(shuffle(array), TYPE_INT, &"", null)


# Feel free to add so many typed versions, that you need.
# Byt for performance reasons you must rewrite code for only type.
# Not a typecasting Variants as above.
# But the typed variables as below.

## String version of shuffle function.
func shuffles(array: Array[String]) -> Array[String]:
	if array.size() == 2: 
		if randbool():
			array.reverse()
	elif array.size() > 2:
		var tmp : String
		var j : int
		for i in range(array.size()-1, -1, -1):
			tmp = array[i]
			j = self.randi() % array.size()
			while j == i: 
				j = self.randi() % array.size()
			array[i] = array[j]
			array[j] = tmp
	return array


func _to_string() -> String:
	return "<-CoRNGen#%s->" % get_instance_id()
