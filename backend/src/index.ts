import express, { Express } from 'express';
import { test_route } from './routes/test';

const app: Express = express();
app.use(express.json())
const port = 8080;

app.post('/hello',  test_route);

app.listen(port, () => {
	console.log(`️[server]: Server is running at http://localhost:${port}`);
});
