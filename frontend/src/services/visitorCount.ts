import { z } from "zod";
import { createZodFetcher } from "zod-fetch";

const functionUrl = "https://resume-backend-dev-function-app.azurewebsites.net/api/GetAndUpdateVisitorCount";
const schema = z.object({
    count: z.number(),
});
export async function getAndUpdateVisitorCount() {
    const fetchWithZod = createZodFetcher();
    try 
    {
        const response = await fetchWithZod(schema, functionUrl);
        return response.count;
    } catch(e) {
        return 0;
    }
}
