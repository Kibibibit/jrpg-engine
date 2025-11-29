extends SkillContext
class_name BattleSkillContext


var signal_bus: BattleSignalBus

func _init(p_signal_bus: BattleSignalBus) -> void:
	signal_bus = p_signal_bus

func do_hit(user: CharacterState, intended_target: CharacterState, hit: Hit) -> void:
	
	var target: CharacterState = intended_target
	if hit.reflected:
		signal_bus.on_reflect.emit(user, target)
		target = user
	
	if hit.damage_amount < 0:
		do_heal(user, target, absi(hit.damage_amount))
	else:
		target.damage(hit.damage_amount)
		signal_bus.on_hit.emit(user, target, hit)
		## TODO: Work out what happens if they're dropped below 0 hp and then revived in the same turn
		if not target.is_alive():
			signal_bus.on_death.emit(target)

	
func do_heal(user: CharacterState, target: CharacterState, amount: int) -> void:
	target.heal(amount)
	signal_bus.on_heal.emit(user, target, amount)
	
func do_defend(user: CharacterState) -> void:
	user.set_is_defending(true)
	
func do_pass(user: CharacterState) -> void:
	signal_bus.request_pass.emit(user)

func apply_ailment(target: CharacterState, ailment: Ailment, succeeded: bool) -> void:
	target.apply_ailment(ailment)
	signal_bus.on_apply_ailment.emit(target, succeeded)
