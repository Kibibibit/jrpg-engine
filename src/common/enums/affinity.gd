@abstract
extends RefCounted
class_name Affinity

enum Type {
	NORMAL,
	WEAK,
	RESIST,
	BLOCK,
	ABSORB,
	REFLECT
}

const PRIORITY: Dictionary[Type, int] = {
	Type.NORMAL: 0,
	Type.WEAK: 1,
	Type.RESIST: 2,
	Type.BLOCK: 3,
	Type.ABSORB: 4,
	Type.REFLECT: 5
}

const NORMAL := Type.NORMAL
const WEAK := Type.WEAK
const RESIST := Type.RESIST
const BLOCK := Type.BLOCK
const ABSORB := Type.ABSORB
const REFLECT := Type.REFLECT

static func get_higher_affinity(a: Type, b: Type) -> Type:
	if PRIORITY[a] > PRIORITY[b]:
		return a
	return b