# This code was copied from the websocket_chat demo code provided by Godot
# under its MIT license terms. See godot.LICENSE.txt for the full license text.
# Copyright (c) 2007-2021 Juan Linietsky, Ariel Manzur.
# Copyright (c) 2014-2021 Godot Engine contributors (cf. AUTHORS.md).

# Modifications for the ALPACASclient project are BSD 3-Clause:
# Copyright (c) 2021, Michael J. Freidel
# See the LICENSE file for the full license text.

extends Node

func encode_data(data, mode):
	if mode == WebSocketPeer.WRITE_MODE_TEXT:
		return data.to_utf8()
	return var2bytes(data)


func decode_data(data, is_string):
	if is_string:
		return data.get_string_from_utf8()
	return bytes2var(data)


# ALPACAS -- Add functions to process JSON data to/from Evennia
func encode_evennia(user_input):
	var input_arr = []
	input_arr.append(user_input)
	var data = JSON.print(["text", input_arr, {}])
	print("Sending JSON string to server: %s" % [data])
	return data.to_utf8()


func decode_evennia(data):
	print("Parsing data: %s" % [data])
	var parsed_data = JSON.parse(data)
	print("Result: %s" % [parsed_data])
	var msg_array = parsed_data.result[1]
	return msg_array[0]
	
# ALPACAS


func _log(node, msg):
	print(msg)
	node.add_text(str(msg) + "\n")
