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
	# !NOTE!
	# This is only implemented in client_ui, where its RichTextLable is not
	# visible. It should probably be updated to become a **real** logging 
	# function at some point.
	#
	print("Displaying message.")
	node.add_text(str(msg) + "\n")

func _art_exists(art_path):
	#
	# Verifies an art_path.
	#
	# All art_path strings in ALPACASclient should be a path to a file in the 
	# context of the 'art' directory. This is used to verify that any reference
	# to art resources are valid before attempting to use them.
	#
	var file_obj = File.new()
	var file_path = "res://art/%s" % art_path
	if file_obj.file_exists(file_path):
		return true
	else:
		return false

func _anchor_node_center_bottom(node):
	node.anchor_left = 0.5
	node.anchor_top = 1
	node.anchor_right = 0.5
	node.anchor_bottom = 1
