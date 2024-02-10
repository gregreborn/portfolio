using System.Text.Json;

namespace TP2_Reseau.Messaging
{
    public class TLVFormatter
    {
        public string CreateTLVPacket(string type, string value)
        {
            var tlv = new
            {
                type = type,
                length = value.Length,
                value = value
            };

            var message = new
            {
                tlv = new[] { tlv }
            };

            return JsonSerializer.Serialize(message);
        }
    }
}