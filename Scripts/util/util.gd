class_name Util extends Node

const bonus_area = Vector2(3,3)

func mouseInArea(mouse_position: Vector2, area: Rect2) -> bool:
	if ( (mouse_position.x >= area.position.x - bonus_area.x && mouse_position.x <= area.position.x + area.size.x + bonus_area.x)
	&& (mouse_position.y >= area.position.y - bonus_area.y && mouse_position.y <= area.position.y + area.size.y + bonus_area.y) ):
		return true
	return false
