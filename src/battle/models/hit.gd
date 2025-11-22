extends RefCounted
class_name Hit

enum HitType {
	NORMAL,
	CRITICAL,
	WEAK,
	RESIST,
	BLOCK,
	MISS
}

var damage_amount: int = 0
var hit_type: HitType = HitType.NORMAL
var reflected: bool = false

func is_critical() -> bool:
	return (hit_type == HitType.CRITICAL or hit_type == HitType.WEAK) and not reflected
