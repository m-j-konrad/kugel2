extends Node


var http_request : HTTPRequest = HTTPRequest.new()

var SERVER_URL = ""
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
const SECRET_KEY = "9365988261"

var nonce = null
var request_queue: Array = []
var is_requesting: bool = false

var highscore_data = {}						# raw data from server
var highscore_formatted: String = ""		# formatted data


func _ready():
	match UserData.settings.last_selected_level:
		1: SERVER_URL = "https://games.mjksoftware.de/kugel2/highscore_1.php"
		2: SERVER_URL = "https://games.mjksoftware.de/kugel2/highscore_2.php"
		3: SERVER_URL = "https://games.mjksoftware.de/kugel2/highscore_3.php"
		4: SERVER_URL = "https://games.mjksoftware.de/kugel2/highscore_4.php"
		5: SERVER_URL = "https://games.mjksoftware.de/kugel2/highscore_5.php"
	
	randomize()
	# Connect our request handler:
	add_child(http_request)
	# warning-ignore:return_value_discarded	
	http_request.connect("request_completed", self, "_http_request_completed")


func _process(_delta):
	# Check if we are good to send a request:
	if is_requesting:
		return
		
	if request_queue.empty():
		return
		
	is_requesting = true
	if nonce == null:
		request_nonce()
	else:
		_send_request(request_queue.pop_front())


func _http_request_completed(_result, _response_code, _headers, _body):
	is_requesting = false
	if _result != HTTPRequest.RESULT_SUCCESS:
		UserData.internet_available = false
		return
	else:
		UserData.internet_available = true
		
	var response_body = _body.get_string_from_utf8()
	# Grab our JSON and handle any errors reported by our PHP code:
	var response = parse_json(response_body)
	if response['error'] != "none":
		return
	
	# Check if we were requesting a nonce:
	if response['command'] == 'get_nonce':
		nonce = response['response']['nonce']
		return
	
	if response['command'] == 'get_scores':
		highscore_data = response['response']
		var hs = highscore_data
		var fhs: String = ""
		
		# the following is only possible with at least 10 entries in teh highscore table !!!
		for i in range(0, 10):
			# format highscore string
			fhs="%s\n\t%d\t%s\t\t\t%s"%[fhs,i+1,Tools.fill_string(hs[str(i)].display_name, 30),hs[str(i)].score]
		highscore_formatted = fhs
		return


func request_nonce():
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.print({})})
	var body = "command=get_nonce&" + data
	
	# Make request to the server:
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, true, HTTPClient.METHOD_POST, body)
	
	# Check if there were problems:
	if err != OK:
		print("HTTPRequest error: " + String(err), "error")
		return


func _send_request(request : Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.print(request['data'])})
	var body = "command=" + request['command'] + "&" + data
	
	# Generate our 'response nonce'
	var cnonce = String(Crypto.new().generate_random_bytes(32)).sha256_text()
	
	# Generate our security hash:
	var client_hash = (nonce + cnonce + body + SECRET_KEY).sha256_text()
	nonce = null
	
	# Create our custom header for the request:
	var headers = SERVER_HEADERS.duplicate()
	headers.push_back("cnonce: " + cnonce)
	headers.push_back("hash: " + client_hash)
	
	# Make request to the server:
	var err = http_request.request(SERVER_URL, headers, false, HTTPClient.METHOD_POST, body)
	
	# Check if there were problems:
	if err != OK:
		return


func _submit_score(score: int):
	# if saved score higher use it -> maybe it wasn't saved last time due to network problems
	match UserData.settings.last_selected_level:
		1:
			if score > UserData.settings.score1:
				UserData.settings.score1 = score
			else:
				score = UserData.settings.score1
		2:
			if score > UserData.settings.score2:
				UserData.settings.score2 = score
			else:
				score = UserData.settings.score2
		3:
			if score > UserData.settings.score3:
				UserData.settings.score3 = score
			else:
				score = UserData.settings.score3
		4:
			if score > UserData.settings.score4:
				UserData.settings.score4 = score
			else:
				score = UserData.settings.score4
		5:
			if score > UserData.settings.score5:
				UserData.settings.score5 = score
			else:
				score = UserData.settings.score5
	
	# if there's no internet connection, don't try to connect!
	if UserData.internet_available:
		var unique_player_name = UserData.settings.unique_player_name
		var display_name = UserData.settings.display_name
		if !(unique_player_name == ""):
			var command = "add_score"
			var data = {"score" : score, "unique_user_name" : unique_player_name, "display_name" : display_name}
			request_queue.push_back({"command" : command, "data" : data})


func _get_scores():
	# if there's no internet connection, don't try to connect!
	if UserData.internet_available:
		var command = "get_scores"
		var data = {"score_offset" : 0, "score_number" : 10}	
		request_queue.push_back({"command" : command, "data" : data});
	else:
		highscore_formatted = tr("no_highscore_available")
