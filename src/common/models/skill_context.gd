@abstract
extends RefCounted
class_name SkillContext

@abstract
func do_hit(user: CharacterState, target: CharacterState, hit: Hit) -> void

@abstract
func do_heal(user: CharacterState, target: CharacterState, amount: int) -> void

@abstract
func do_defend(user: CharacterState) -> void

@abstract
func do_pass(user: CharacterState) -> void

@abstract
func apply_ailment(target: CharacterState, ailment: Ailment)
