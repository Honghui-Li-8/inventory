import { Request, Response } from "express";

export interface Route {
    (req: Request, res: Response): void;
}