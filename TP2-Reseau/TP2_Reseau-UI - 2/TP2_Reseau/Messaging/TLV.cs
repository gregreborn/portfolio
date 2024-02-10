using System.Text.Json.Serialization;

namespace TP2_Reseau.Messaging;

public class TLV
{
    public string Type { get; set; }
    public int Length { get; set; }
    [JsonPropertyName("value")]
    public string Value { get; set; }
    [JsonPropertyName("recipientId")]
    public string RecipientID { get; set; } // This should match the JSON key exactly as expected by the server

    public string Protocol { get; set; }
}