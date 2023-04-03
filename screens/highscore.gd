extends Control


var attempts_get_score: int = 0


func _ready():
	$lblTitle2.text = "»"+Tools.level_name(UserData.settings.last_selected_level)+"«\n"+tr("Highscore_lblTitle2")
	$txtHighscoreTable.text = $Network.highscore_formatted
	$CheckInternetConnection.test_internet()


func _on_btnQuit_pressed():
	Tools.quit_game()


func _on_btnRestart_pressed():
	Tools.choose_level()


func _on_CheckInternetConnection_done():
	$Network._submit_score(UserData.game_score)
	$Network._get_scores()
	UserData.save_settings()
	$txtHighscoreTable.text = $Network.highscore_formatted
	$NetRetryTimer.start(2)


func _on_NetRetryTimer_timeout():
	$txtHighscoreTable.text = $Network.highscore_formatted
	attempts_get_score += 1
	if attempts_get_score < 10:
		$NetRetryTimer.start(2)

