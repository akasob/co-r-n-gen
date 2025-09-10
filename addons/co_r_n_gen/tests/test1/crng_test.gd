class_name CoRNGenTest extends RefCounted

static func run(instance: CoRNGen, rollback_state := false) -> void:
	if not instance:
		instance = CoRNGen.new()
	var stored_state := instance.state
	_inner_test(instance)
	if rollback_state:
		instance.state = stored_state

static func _inner_test(r: CoRNGen) -> void:
	var mtarr := ["su","mo","tu","we","th","fr","sa", 0,1,2,3,4,5,6,7,8,9,3,1.24,.3,.7]
	print(r.riffle(r.shuffle(mtarr)))
	print(r.shuffle(mtarr))
	print(r.can_hold_types(mtarr))
	
	#var iiss := []
	#iiss.resize(10)
	#iiss.fill("bl")
	#for i in iiss.size():
		#iiss[i] = r.pick_random(["Hds", "Tls", "Stk", "Flt"])
		#iiss.append(r.return_or_not(coin, &"stuck"))
		#iiss.append(r.return_or_not(coin.bind(&"O", &"I"), &"A"))
		#iiss.append(r.return_or_not(dice.bind(1, 8), -1))
	#prints("arrayy:", iiss)
	
	var roll: int
	for lucky in r.chance_table(3, 5):
		if lucky:
			roll = r.dice(1,12,-3)
			print("1d12 with bonus -3: %s" % roll)
		else:
			roll = max(r.dice(1,6), r.dice(1,6))
			print('max of 2d6: %s' % roll)
	
	var deck := ["BJ", "RJ"]
	for suit in ["в™Ґ", "в™Ј", "в™ ", "в™¦"]:
		for card in ['A',2,3,4,5,6,7,8,9,10,'J','D','K']:
			deck.append("%s%s" % [card, suit])
	print(r.shuffle(deck))
	print(r.riffle(deck))
	
