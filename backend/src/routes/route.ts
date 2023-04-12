import { Request, Response } from "express";
import { test_route } from "./test";
import { create_user, get_all_users, get_user } from "./user";

export interface Route {
	route: string;
	method: "get" | "post" | "put" | "delete";
	handler: (req: Request, res: Response) => void;
}

export const routes = [test_route, get_all_users, get_user, create_user];
