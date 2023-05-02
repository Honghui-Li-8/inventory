import { Household } from "../models/types";
import { DataStoreService } from "../services/datastore";
import { Route } from "./route";

export const createHousehold: Route = {
	route: "/Household",
	method: "post",
	async handler(req, res) {
        try {
		const users = await DataStoreService.instance.CreateHousehold(req.body as Household);
		res.json(users).status(200).send();
        } catch (e) {
            console.log(e)
            res.status(404).json({error: "Could not find household"}).send();
        }
	},
};

export const getHousehold: Route = {
	route: "/Household/:id",
	method: "get",
	async handler(req, res) {
		try {
			const user = await DataStoreService.instance.getHousehold(req.params.id);
			res.json(user).status(200).send();
		} catch (e) {
			res.status(404).json({ error: "Could Not Find Household" }).send();
		}
	},
};