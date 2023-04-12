import { User } from "../models/types";
import { DataStoreService } from "../services/datastore";
import { Route } from "./route";

export const get_all_users: Route = {
	route: "/users",
	method: "get",
	async handler(req, res) {
		const users = await DataStoreService.getInstance().getUsers();
		res.json(users).status(200).send();
	},
};

export const get_user: Route = {
	route: "/users/:uid",
	method: "get",
	async handler(req, res) {
		try {
			const user = await DataStoreService.getInstance().getUser(req.params.uid);
			res.json(user).status(200).send();
		} catch (e) {
			res.status(404).json({ error: "could not find user" }).send();
		}
	},
};

export const create_user: Route = {
	route: "/users",
	method: "post",
	async handler(req, res) {
		let userData: User = req.body;
		try {
			await DataStoreService.getInstance().createUser(userData);
			res.status(201).send();
		} catch (e) {
			res.json({ error: e }).status(500).send();
		}
	},
};
