# utils.gd
# Game-wide utilities for the client code

# This code was copied from the websocket_chat demo code provided by Godot
# under its MIT license terms. See godot.LICENSE.txt for the full license text.
# Copyright (c) 2007-2021 Juan Linietsky, Ariel Manzur.
# Copyright (c) 2014-2021 Godot Engine contributors (cf. AUTHORS.md).

# Modifications for the ALPACASclient project are BSD 3-Clause:
# Copyright (c) 2021, Michael J. Freidel
# See the LICENSE file for the full license text.

extends Node

func encode_evennia(input_array):
	#
	# Convert an input array into utf8-formatted JSON string.
	#
	
	# This could probably use some input validation.
	var data = JSON.print(input_array)
	return data.to_utf8()


func decode_evennia(data_string):
	#
	# Convert a JSON string into an Evennia array.
	# Note that the input is a *string*, and NOT utf8 data.
	# Passing packet data to this requires converting its payload to a string 
	# *before* decoding it with this function.
	#
	
	# This could probably use some input validation.
	var parsed_data = JSON.parse(data_string)
	return parsed_data.result
	


func _log(node, msg):
	#
	# Send text output to a specific node.
	#
	print("Displaying message.")
	node.add_text(str(msg) + "\n")
