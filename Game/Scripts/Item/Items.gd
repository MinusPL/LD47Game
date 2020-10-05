extends Node

const itemImages = [
	preload("res://Assets/Items/knife.png"),
	preload("res://Assets/Items/vase.png"),
	preload("res://Assets/Items/button.png"),
	preload("res://Assets/Items/hair.png"),
	preload("res://Assets/Items/paper.png"),
];

const itemDictionary = {
	0: {
		"itemName": "Bloody knife",
		"itemDesc": "Very wierd knife. Who cares about knives?",
		"texture": itemImages[0],
	},
	1: {
		"itemName": "Bloody vase",
		"itemDesc": "Uuuuu URNA",
		"texture": itemImages[1],
	},
	2: {
		"itemName": "Gold button",
		"itemDesc": "Uuuuu URNA",
		"texture": itemImages[2],
	},
	3: {
		"itemName": "Red hair",
		"itemDesc": "Uuuuu URNA",
		"texture": itemImages[3],
	},
	4: {
		"itemName": "Piece of burnt paper",
		"itemDesc": "Uuuuu URNA",
		"texture": itemImages[4],
	}
};
