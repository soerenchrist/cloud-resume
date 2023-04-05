using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Azure.Data.Tables;
using Backend.Models;
using Azure;
using Azure.Storage.Blobs;

namespace backend
{
    public static class GetPdfResumeAndUpdateDownloadCount
    {
        [FunctionName("GetPdfResumeAndUpdateDownloadCount")]
        public static IActionResult Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequest req,
            [Table("Visitors", Connection = "CosmosDbConnection")] TableClient tableClient,
            [Blob("data/soeren_christ_resume.pdf", FileAccess.Read, Connection = "StorageAccountBlobConnection")] BlobClient blobClient,
            ILogger log)
        {
            UpdateDownloadCounter(tableClient);

/*
            var memoryStream = new MemoryStream();
            blob.CopyTo(memoryStream);
            memoryStream.Position = 0;
            return new FileStreamResult(memoryStream, "application/pdf");
            */
            return new OkObjectResult("Works");
        }

        private static void UpdateDownloadCounter(TableClient tableClient)
        {
            try
            {
                var visitorCount = tableClient.GetEntity<InteractionCount>("1", "PdfDownloads").Value;
                visitorCount.Count++;

                tableClient.UpdateEntity<InteractionCount>(visitorCount, ETag.All);
            }
            catch (RequestFailedException)
            {
                var visitorCount = new InteractionCount 
                {
                    PartitionKey = "1",
                    RowKey = "PdfDownloads",
                    Count = 1
                };

                tableClient.AddEntity(visitorCount);
            }
        }
    }
}
