extends Node

signal status_change

var buyers = 0:
	set(value):
		buyers = value
		status_change.emit()

var sellers = 0:
	set(value):
		sellers = value
		status_change.emit()

var price = 0:
	set(value):
		price = value
		status_change.emit()
