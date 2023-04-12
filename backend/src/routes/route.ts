import { Request, Response } from "express";
import { test_route } from "./test";

export interface Route {
    route: string,
    method: "get" | "post" | "put" | "delete",
    handler: (req: Request, res: Response) => void,
}

export const routes = [
    test_route
]