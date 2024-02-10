using System;
using System.Text.Json.Serialization;

namespace TP2_Reseau.Models;

public class MessageModel
{
    [JsonPropertyName("SenderId")]
    public string SenderId { get; set; }

    [JsonPropertyName("RecipientId")]
    public string RecipientID { get; set; }

    [JsonPropertyName("Content")]
    public string Content { get; set; }

    [JsonPropertyName("Timestamp")]
    public DateTime Timestamp { get; set; }

    [JsonPropertyName("PreferredProtocol")]
    public string PreferredProtocol { get; set; }
    public MessageModel(string senderId, string recipientId, string content, DateTime timestamp, string preferredProtocol = "TCP")
    {
        SenderId = senderId;
        RecipientID = recipientId;
        Content = content;
        Timestamp = timestamp;
        PreferredProtocol = preferredProtocol;
    }
}
