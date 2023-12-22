extends Node

var last_level = ""

var states = {}

const positions = {
	"level1": { 
		"": {
			"x": 104,
			"y": 120
		},
		"level2": {
			"x": 192,
			"y": 20
		}
	},
	"level2": { 
		"level1": {
			"x": 96,
			"y": 176
		}
	}
	
}
