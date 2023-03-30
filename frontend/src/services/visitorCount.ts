import { z } from "zod";
import { createZodFetcher } from "zod-fetch";

//const functionUrl = "https://resume-backend-dev-function-app.azurewebsites.net/api/GetAndUpdateVisitorCount";

const schema = z.object({
    count: z.number(),
});

function getFunctionUrl() {
    if (import.meta.env.MODE === "development") {
        return "https://resume-backend-dev-function-app.azurewebsites.net/api/GetAndUpdateVisitorCount";
    }
    return "https://resume-backend-prod-function-app.azurewebsites.net/api/GetAndUpdateVisitorCount"
}

export async function getAndUpdateVisitorCount() {
    const fetchWithZod = createZodFetcher();
    try 
    {
        const response = await fetchWithZod(schema, getFunctionUrl());
        return response.count;
    } catch(e) {
        return 0;
    }
}
