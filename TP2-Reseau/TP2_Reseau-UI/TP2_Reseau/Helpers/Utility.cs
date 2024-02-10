using System.Text.Json;
using TP2_Reseau.Models;

public static class Utility
{

    public static MessageModel DeserializeMessage(string messageString)
    {
        try
        {
            return JsonSerializer.Deserialize<MessageModel>(messageString);
        }
        catch (JsonException)
        {
            return null;
        }
    }
}