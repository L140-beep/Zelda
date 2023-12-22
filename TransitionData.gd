extends Node

var last_level = ""

var states = {}

const positions = {
	"level1": { 
		"": {
			"x": 133,
			"y": 55
		},
		"level2": {
			"x": 656,
			"y": 128
		}
	},
	"level2": { 
		"level1": {
			"x": 64,
			"y": 176
		}
	}
	
}
