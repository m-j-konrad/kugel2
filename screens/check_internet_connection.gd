# Shows a little animation and text on the bottom of the screen
# Hides itself when connection was found
# Shows a full screen with options if not.
extends Control


signal done


func _ready():
	# when loaded, nothin is visible
	visible = false
	$btnJustPractise.visible = false
	$btnTryAgain.visible = false
	$Animation/Sprite.visible = false


func test_internet():
	# nothing but the animation and the message at the bottom will be visible
	$lblTitle.align = Label.ALIGN_RIGHT
	$lblTitle.valign = Label.VALIGN_BOTTOM
	$Animation/Sprite.visible = true	
	$AnimationPlayer.play("rotate")
	$btnJustPractise.visible = false
	$btnTryAgain.visible = false
	$ColorRectBackground.visible = false
	# show "searching internet" label text
	$lblTitle.text = "CheckInternetConnection_lblTitle"
	
	# show this screen
	visible = true
	
	# for now, we assume that everything is okay.
	UserData.internet_available = true	
	
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

	# Perform the HTTP request. The URL below returns a simple text file.
	var _error = http_request.request("https://games.mjksoftware.de/kugel2/check_connection")
	


# Called when the HTTP request is completed.
func _http_request_completed(result, _response_code, _headers, _body):
	if result == HTTPRequest.RESULT_SUCCESS:
		# success -> internet is available
		$lblTitle.text = "network_ok"
		UserData.internet_available = true
		# start timer to keep message a second
		$Timer2.start(1)
	else:
		# other result -> no internet connection (or server down...)
		$lblTitle.align = Label.ALIGN_CENTER
		$lblTitle.valign = Label.ALIGN_CENTER
		$lblTitle.text = "no_network"
		$Animation/Sprite.visible = false
		$ColorRectBackground.visible = true
		$btnJustPractise.visible = true
		$btnTryAgain.visible = true
		UserData.internet_available = false


func _on_btnTryAgain_pressed():
	test_internet()


func _on_btnJustPractise_pressed():
	visible = false
	emit_signal("done")


func _on_Timer2_timeout():
	visible = false
	emit_signal("done")
