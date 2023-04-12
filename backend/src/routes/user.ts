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
