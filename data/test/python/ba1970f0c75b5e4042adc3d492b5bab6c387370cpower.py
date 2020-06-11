import Scripts.effects as Effect

def power(self, controller, user):
	targets = controller.get_targets(self, user)
	if targets == []:
		return
	target = targets[0]
	
	controller.animate_spell(user, "cast")

	for target in targets:
		amount = -.1 * self.tier
		controller.add_status(target, "Reflex", amount, 2)
		controller.add_status(target, "Arcane Defense", amount, 2)
		
		pos = target.object.position
		ori = target.object.get_orientation()
		effect = Effect.StaticEffect("small_smoke", pos, ori, 50)
		controller.add_effect(effect)

		effect = Effect.StaticEffect("skull_smoke", pos, ori, 120)
		controller.add_effect(effect)