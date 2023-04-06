using System;
using Azure;
using Azure.Data.Tables;

namespace Backend.Models;

public class InteractionCount : ITableEntity
{
    public string PartitionKey { get; set; }
    public string RowKey { get; set; }
    public int Count { get; set; }
    public ETag ETag { get; set; }
    public DateTimeOffset? Timestamp { get; set; }
}