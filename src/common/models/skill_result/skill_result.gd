@abstract
extends RefCounted
class_name SkillResult

var user: CharacterState
var target: CharacterState

@abstract func apply(skill_context: SkillContext) -> void
@abstract func is_critical() -> bool
