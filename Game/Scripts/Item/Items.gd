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
		"itemName": "a Bloody knife",
		"itemDesc": "It's a small decorated knife, found in the victim's back",
		"texture": itemImages[0],
	},
	1: {
		"itemName": "a Bloody vase",
		"itemDesc": "It's a heavy vase. It's covered in blood",
		"texture": itemImages[1],
	},
	2: {
		"itemName": "a Gold button",
		"itemDesc": "A golden button from an overcoat",
		"texture": itemImages[2],
	},
	3: {
		"itemName": "Red hair",
		"itemDesc": "Some red hair",
		"texture": itemImages[3],
	},
	4: {
		"itemName": "a Piece of burnt paper",
		"itemDesc": "The paper is burnt but you can make out a bit of text \"He is getting too close\" and \"at to do.\"",
		"texture": itemImages[4],
	}
};
