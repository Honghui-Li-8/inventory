import { Household, Invitation } from "../models/types";
import { DataStoreService } from "../services/datastore";
import { Route } from "./route";

export const createHousehold: Route = {
	route: "/households",
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
	route: "/households/:id",
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

export const getHouseholds: Route = {
    route: "/getHouseholds",
    method: "post",
    async handler(req, res) {
        const householdIds: string[] = req.body;
        const households: Household[] = [];
        console.log(householdIds);
        for(let id of householdIds) {
            households.push(await DataStoreService.instance.getHousehold(id));
        }
        res.json(households).status(200).send();
    }

}

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

export const deleteUser: Route = {
    route: "/deleteUser",
    method: "delete",
    async handler(req,res) {
        const uid = req.body.uid;
        const hid = req.body.hid;
        const oid = req.body.oid;
        await Promise.all([DataStoreService.instance.deleteUser(uid,hid), DataStoreService.instance.deleteHousehold(uid,hid),]);
        res.status(200).send();
    }
}
