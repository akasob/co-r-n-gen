## Convenient random number generator with handy methods.
class_name CoRNGen extends RandomNumberGenerator


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
		while result[index]: # Searching 'false'
			index = wrapi(index + self.randi() % of, 0,  of - 1)
			#index = posmod(index + posmod(self.randi(), what), of)
		result[index] = true # and make it 'true'
	
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


## Reimplementation of engine function within generator instance.
func shuffle(what: Array, type_mixing := false) -> Array:
	if what.size() == 2: 
		if randbool():
			what.reverse()
	elif what.size() > 2:
		var type_count := func(idx: int) -> int:
			return what.filter(func(item): return typeof(item) == typeof(what[idx])).size()
		var is_equal := func(idx1: int, idx2: int) -> bool:
			if idx1 == idx2:
				return true
			if type_mixing:
				return false
			if type_count.call(idx1) < 2 or type_count.call(idx2) < 2:
				return false
			#var is_type_count_1 = type_count.call(typeof(what[idx1])) < 2
			#var is_type_count_2 = type_count.call(typeof(what[idx2])) < 2
			#var cnts_fail = is_type_count_1 or is_type_count_2
			#var is_t_nt_eq = typeof(what[idx1]) != typeof(what[idx2])
			#prints("counts:", one_of_counts_fail)
			return typeof(what[idx1]) != typeof(what[idx2])
		var tmp # Variant
		var j : int
		for i in range(what.size()-1, -1, -1):
			j = self.randi() % what.size()
			while is_equal.call(i, j): # (i == j) or (not type_mixing and typeof(what[i]) != typeof(what[j])): #
				j = self.randi() % what.size()
			tmp = what[i]
			what[i] = what[j]
			what[j] = tmp
	return what


## Boolean version of shuffle function.
func shuffleb(what: Array[bool]) -> Array[bool]:
	return Array(shuffle(what), TYPE_BOOL, &"", null)

## Floating-point version of shuffle function.
func shufflef(what: Array[float]) -> Array[float]:
	return Array(shuffle(what), TYPE_FLOAT, &"", null)

## Integer version of shuffle function.
func shufflei(what: Array[int]) -> Array[int]:
	return Array(shuffle(what), TYPE_INT, &"", null)

## Packed Int32 version of shuffle function.
func shuffleip(what: PackedInt32Array) -> PackedInt32Array:
	return Array(shuffle(what), TYPE_INT, &"", null)

# Feel free to add so many typed versions, that you need.
# Byt for performance reasons you must rewrite code for only type.
# Not a typecasting Variants as above.
# But the typed variables as below.

## String version of shuffle function.
func shuffles(what: Array[String]) -> Array[String]:
	if what.size() == 2: 
		if randbool():
			what.reverse()
	elif what.size() > 2:
		var tmp : String
		var j : int
		for i in range(what.size()-1, -1, -1):
			tmp = what[i]
			j = self.randi() % what.size()
			what[i] = what[j]
			what[j] = tmp
	return what


func test(rollback_state := false) -> void:
	var stored_state := self.state
	
	print(shuffle(["su","mo","tu","we","th","fr","sa", 0,1,2,3,4,5,6,7,8,9,3,124,3.9,7]))
	return
	#var iiss := []
	#iiss.resize(10)
	#iiss.fill("bl")
	#for i in iiss.size():
		#iiss[i] = pick_random(["Hds", "Tls", "Stk", "Flt"])
		#iiss.append(return_or_not(coin, &"stuck"))
		#iiss.append(return_or_not(coin.bind(&"O", &"I"), &"A"))
		#iiss.append(return_or_not(dice.bind(1, 8), -1))
	#prints("arrayy:", iiss)
	
	var roll: int
	for lucky in chance_table(3, 5):
		if lucky:
			roll = dice(1,12,-3)
			print("1d12 with bonus -3: %s" % roll)
		else:
			roll = max(dice(1,6), dice(1,6))
			print('max of 2d6: %s' % roll)
	
	var deck := ["BJ", "RJ"]
	for suit in ["в™Ґ", "в™Ј", "в™ ", "в™¦"]:
		for card in ['A',2,3,4,5,6,7,8,9,10,'J','D','K']:
			deck.append("%s%s" % [card, suit])
	print(shuffle(deck))
	
	if rollback_state:
		self.state = stored_state


func _to_string() -> String:
	return "<-CoRNGen#%s->" % get_instance_id()
