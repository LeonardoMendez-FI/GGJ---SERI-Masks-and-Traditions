extends Resource
class_name Stages_List

@export var Stage:GameConstants.STAGES_LEVELS
@export var Forces:Forces_List
@export var Creator:Dictionary[GameConstants.FORCES_RANGE,int] = {
	GameConstants.FORCES_RANGE.Range1: 100,
	GameConstants.FORCES_RANGE.Range2: 0,
	GameConstants.FORCES_RANGE.Range3: 0,
	GameConstants.FORCES_RANGE.Range4: 0
}

@export var Multiplicator:Dictionary[int, int] = {
	1: 100,
	2: 0,
	3: 0
}
