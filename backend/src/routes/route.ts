import { Request, Response } from "express";
import { getInventory, setInventoryItems } from "./inventory";
import { createUser, getAllUsers, getUser, userExists } from "./user";
import {
	createHousehold,
	getHousehold,
	getHouseholds,
	inviteToHousehold,
	deleteUser,
} from "./household";

export interface Route {
	route: string;
	method: "get" | "post" | "put" | "delete";
	handler: (req: Request, res: Response) => void;
}

export const routes = [
	getAllUsers,
	getUser,
	createUser,
	getInventory,
	setInventoryItems,
	createHousehold,
	getHousehold,
	getHouseholds,
	userExists,
	inviteToHousehold,
	deleteUser,
];
