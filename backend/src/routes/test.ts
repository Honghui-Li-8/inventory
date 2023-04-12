import { User } from "../models/types";
import { Route } from "./route";

export const test_route: Route = {
    route: "/hello",
    method: "post",
    handler: (req, res) => {
        let user: User = req.body;
        console.log(user);
        res.send(`Hello, ${user.fname} ${user.lname}`)
    }
}