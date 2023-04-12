import { Datastore } from "@google-cloud/datastore";
import { User } from "../models/types";

export class DataStoreService {
	private datastore: Datastore;
	private static instance?: DataStoreService;

	private constructor() {
		this.datastore = new Datastore();
	}

	public static getInstance(): DataStoreService {
		if (!this.instance) {
			this.instance = new DataStoreService();
		}

		return this.instance;
	}

	public async getUsers(): Promise<User[]> {
		const query = this.datastore.createQuery("User");
		const [users] = await this.datastore.runQuery(query);
		return users as User[];
	}
}
