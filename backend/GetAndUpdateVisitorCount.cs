using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Azure.Data.Tables;
using Azure;
using Backend.Models;

namespace VisitorCountFunction
{
    public static class GetAndUpdateVisitorCount
    {
        [FunctionName("GetAndUpdateVisitorCount")]
        public static IActionResult Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequest req,
            [Table("Visitors", Connection = "CosmosDbConnection")] TableClient tableClient,
            ILogger log)
        {
            try
            {
                var visitorCount = tableClient.GetEntity<InteractionCount>("1", "VisitCount").Value;
                log.LogInformation($"Visitor count is {visitorCount.Count}");
                visitorCount.Count++;

                tableClient.UpdateEntity<InteractionCount>(visitorCount, ETag.All);
                return new OkObjectResult(visitorCount);
            }
            catch (RequestFailedException)
            {
                var visitorCount = new InteractionCount
                {
                    PartitionKey = "1",
                    RowKey = "VisitCount",
                    Count = 1
                };

                tableClient.AddEntity(visitorCount);
                return new OkObjectResult(visitorCount);
            }
        }
    }
}
