using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace TP2_Reseau.Messaging;

public class TLVPacket
{
    [JsonPropertyName("tlv")]
    public List<TLV> Tlv { get; set; }

    
}