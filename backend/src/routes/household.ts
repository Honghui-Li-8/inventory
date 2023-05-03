import { Household, Invitation } from "../models/types";
import { DataStoreService } from "../services/datastore";
import { Route } from "./route";

export const createHousehold: Route = {
	route: "/household",
	method: "post",
	async handler(req, res) {
		try {
			const users = await DataStoreService.instance.createHousehold(
				req.body as Household
			);
			res.json(users).status(200).send();
		} catch (e) {
			console.log(e);
			res.status(404).json({ error: "Could not create household" }).send();
		}
	},
};

export const getHousehold: Route = {
	route: "/household/:id",
	method: "get",
	async handler(req, res) {
		try {
			const household = await DataStoreService.instance.getHousehold(
				req.params.id
			);
			res.json(household).status(200).send();
		} catch (e) {
			res.status(404).json({ error: "Could Not Find Household" }).send();
		}
	},
};

export const inviteToHousehold: Route = {
	route: "/invitations",
	method: "post",
	async handler(req, res) {
		const household = await DataStoreService.instance.createInvitation(
			req.body as Invitation
		);
		res.json(household).status(200).send();
	},
};
