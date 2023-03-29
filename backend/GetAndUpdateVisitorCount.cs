using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Azure.Data.Tables;
using Azure;

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
                var visitorCount = tableClient.GetEntity<VisitorCount>("1", "1").Value;
                log.LogInformation($"Visitor count is {visitorCount.Count}");
                visitorCount.Count++;

                tableClient.UpdateEntity<VisitorCount>(visitorCount, ETag.All);
                return new OkObjectResult(visitorCount);
            }
            catch (RequestFailedException)
            {
                var visitorCount = new VisitorCount
                {
                    PartitionKey = "1",
                    RowKey = "1",
                    Count = 1
                };

                tableClient.AddEntity(visitorCount);
                return new OkObjectResult(visitorCount);
            }
        }

        public class VisitorCount : ITableEntity
        {
            public string PartitionKey { get; set; }
            public string RowKey { get; set; }
            public int Count { get; set; }
            public ETag ETag { get; set; }
            public DateTimeOffset? Timestamp { get; set; }
        }
    }
}
