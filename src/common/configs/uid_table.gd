@abstract
extends RefCounted
class_name UIDTable

const DATA: Dictionary[StringName, String] = {
	&"skin/default": "uid://b2q0uxd167ouo",

	&"skill/basic_attack": "uid://68b4t6v51l05",
	&"skill/basic_attack/instance": "uid://jrfaq7r5cja2",

	&"skill/defend": "uid://ccrpmqx65jvdm",
	&"skill/defend/instance": "uid://clyxerewblcie",
	
	&"skill/pass": "uid://bqnoyv1wgote2",
	&"skill/pass/instance": "uid://r5nhswlp40m7",
	
	&"skill/nothing": "uid://csstxyr5bvy3i",
	&"skill/nothing/instance": "uid://r5nhswlp40m7",
	
	&"skill/frenzy": "uid://djluqe51vf2ck",
	&"skill/frenzy/instance": "uid://jrfaq7r5cja2",

	&"skill/multi_hit": "uid://dlekop3bcjqj6",
	&"skill/multi_hit/instance": "uid://jrfaq7r5cja2",
	
	&"skill/fire/single/light": "uid://dvajb4vkbem1a",
	&"skill/fire/single/light/instance": "uid://drkqmninv5ykc",
	
	&"skill/charm": "uid://hbfc4aysg1qi",
	&"skill/charm/instance": "uid://bjxays74tw7sn",
	
	&"skill/heal/single/small": "uid://csypc8vu2d4cu",
	&"skill/heal/single/small/instance": "uid://djjlsjjqxwetg"
	

}

static func lookup(id: StringName) -> String:
	if id in DATA:
		return DATA[id]
	else:
		push_error("UIDTable: ID '%s' not found in UID table." % id)
		return ""
