export interface User {
	fname: string;
	lname: string;
	email: string;
	uid: string;
	photoURL: string;
	households: string[]; // list of household ids
	inventory: string; // inventory id
}

export interface Inventory {
	uid: string;
	items: Item[];
}

export interface Item {
	name: string;
	quantity: number;
	tags: string[];
}

export interface Household {
	uid: string;
	owner: string;
	inventory: string; // inventory id
	members: string[]; // list of user ids
}
