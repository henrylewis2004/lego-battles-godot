class_name PlayerInformation

class PlayerInfoDetails:
	var playerName: String = "Player"
	var playerCard_index: int = 0

var info: PlayerInfoDetails

func getPlayerInfo() -> PlayerInfoDetails:
	return info
	
func setPlayerName(name: String) -> void:
	info.playerName = name
	
func setPlayerCardIndex(index: int) -> void:
	info.playerCard_index = index
	
func setPlayerInfo(name: String, index: int) -> void:
	setPlayerName(name)
	setPlayerCardIndex(index)
