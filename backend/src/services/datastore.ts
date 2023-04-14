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

	public async getUser(uid: string): Promise<User> {
		const key = this.datastore.key(["User", uid]);
		const [user] = await this.datastore.get(key);
		if (!user) {
			throw new Error("User not found");
		}
		return user as User;
	}

	public async createUser(user: User): Promise<void> {
		const userKey = this.datastore.key(["User", user.uid]);
		const newUser = {
			key: userKey,
			data: user,
		};

		try {
			await this.datastore.save(newUser);
		} catch (e) {
			throw new Error("could not create user");
		}
	}
}
