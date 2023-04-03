extends Control


signal done

const UPDATE_CHECK_FILE: String = "user://version.txt"
var version_local: int = UserData.version
var version_server: int = 1


func _ready():
	visible = false
	$btnNo.visible = false
	$btnYes.visible = false
	$Animation/Sprite.visible = false


func download(link, path):
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_http_request_completed")
	http.set_download_file(path)
	var request = http.request(link)
	if request != OK:
		push_error("Http request error")


func _http_request_completed(result, _response_code, _headers, _body):
	if result != OK:
		push_error("Download Failed")
	else:
		var file := File.new()
		# warning-ignore:return_value_discarded
		file.open(UPDATE_CHECK_FILE, File.READ)
		version_server = int(file.get_line())
	
	if version_local < version_server:
		$lblTitle.align = Label.ALIGN_CENTER
		$lblTitle.valign = Label.ALIGN_CENTER
		$lblTitle.text = "update_available"
		$Animation/Sprite.visible = false
		$ColorRectBackground.visible = true
		$btnYes.visible = true
		$btnNo.visible = true
		print("Neue Version!")
	else:
		visible = false
		emit_signal("done")


func check_for_update():
	# delete old installation file(s) if exist
	# !TODO: the file can just be loaded to download directory... can get access to del them there?
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.begins_with("kugel2"):
			dir.remove(file)
	dir.list_dir_end()

	if not UserData.internet_available:
		emit_signal("done")
	else:
		$lblTitle.align = Label.ALIGN_RIGHT
		$lblTitle.valign = Label.VALIGN_BOTTOM
		$Animation/Sprite.visible = true
		
		$AnimationPlayer.play("rotate")
		$btnYes.visible = false
		$btnNo.visible = false
		$ColorRectBackground.visible = false
		# show this screen
		visible = true
		# show "searching internet" label text
		$lblTitle.text = "search_update"
		
		var file := File.new()
		if not file.file_exists(UPDATE_CHECK_FILE):
			#version_local = 0
			pass
		else:
			# warning-ignore:return_value_discarded
			file.open(UPDATE_CHECK_FILE, File.READ)
			version_local = int(file.get_line())
		
		download("https://games.mjksoftware.de/kugel2/version.txt", "user://version.txt")

func _on_btnNo_pressed():
	visible = false
	var file := File.new()
	# warning-ignore:return_value_discarded
	file.open(UPDATE_CHECK_FILE, File.WRITE)
	file.store_line(str(version_local))
	emit_signal("done")


func _on_btnYes_pressed():
	# warning-ignore:return_value_discarded
	OS.shell_open("https://games.mjksoftware.de/kugel2/kugel2.apk")
	visible = false
	emit_signal("done")

