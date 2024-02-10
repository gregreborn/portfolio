using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.WebSockets;
using System.Text;
using TP2_Reseau.Models;
using System.Text.Json;
using System.Threading.Tasks;
using TP2_Reseau.Encryption;
using TP2_Reseau.Messaging;

namespace TP2_Reseau.Services
{
    public class PeerInfo
    {
        public string Id { get; set; }
        public string Address { get; set; }
        public string PublicKey { get; set; }
        public string tcp_address { get; set; }
        public string udp_address { get; set; }
        public string Preferred_Protocol { get; set; }
        public string CryptoSalt { get; set; }
        public string DisplayText { get; set; }
    }



    public class ChatService
    {
        private WebSocketService _webSocketService;
        private readonly EncryptionService _encryptionService;
        private string _currentEncryptionKey; // Variable to store the current encryption key

        public event Action<MessageModel> MessageReceived;

        public ChatService(EncryptionService encryptionService, string encryptionKey)
        {
            _encryptionService = encryptionService;
            _currentEncryptionKey = encryptionKey; // Use the passed key
        }


        // Method to fetch the list of peers from the server
        public async Task<Dictionary<string, PeerInfo>> FetchPeersAsync(string serverUri)
        {
            using var httpClient = new HttpClient();
            var response = await httpClient.GetAsync($"{serverUri}/peers");
            response.EnsureSuccessStatusCode();
            var content = await response.Content.ReadAsStringAsync();
            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true,
            };
            return JsonSerializer.Deserialize<Dictionary<string, PeerInfo>>(content, options);
        }
        
        // Connect to the server using the WebSocket service
        public async Task ConnectAsync(string serverUri)
        {
            _webSocketService?.Dispose(); // Dispose the previous instance if any
            _webSocketService = new WebSocketService(serverUri);
            _webSocketService.MessageReceived += OnMessageReceived; // Register event handler
            await _webSocketService.ConnectAsync();
        }

        // Send a message to a specific peer
        public async Task SendMessageAsync(string tlvPacket)
        {
            if (_webSocketService == null || _webSocketService.State != WebSocketState.Open)
            {
                throw new InvalidOperationException("WebSocket is not connected.");
            }

            // Assuming the TLV packet is correctly formatted and serialized, send it directly
            await _webSocketService.SendMessageAsync(tlvPacket);
        }






        // Event handler for receiving messages from the WebSocket service
        private void OnMessageReceived(object sender, WebSocketService.MessageReceivedEventArgs args)
        {
            try
            {
                Console.WriteLine($"Received message: {args.Message}"); // Log the received message for debugging

                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                var tlvPacket = JsonSerializer.Deserialize<TLVPacket>(args.Message, options);

                if (tlvPacket?.Tlv != null)
                {
                    foreach (var tlv in tlvPacket.Tlv)
                    {
                        if (tlv.Type == "chat")
                        {
                            // Decrypt the content
                            var decryptedContent = _encryptionService.Decrypt(tlv.Value, _currentEncryptionKey);

                            // Create a new MessageModel with the decrypted content and other details
                            var message = new MessageModel(
                                senderId: "uuid2", // Replace with actual sender's ID
                                recipientId: tlv.RecipientID,
                                content: decryptedContent,
                                timestamp: DateTime.Now
                            );

                            NotifyMessageReceived(message);
                        }
                    }
                }
            }
            catch (JsonException jsonEx)
            {
                // Handle JSON deserialization errors
                Console.WriteLine($"JSON Deserialization error: {jsonEx.Message}");
            }
        }






        private void NotifyMessageReceived(MessageModel message)
        {
            MessageReceived?.Invoke(message);
        }

        // Disconnect from the WebSocket server
        public async Task DisconnectAsync()
        {
            if (_webSocketService != null)
            {
                await _webSocketService.CloseAsync();
                _webSocketService.Dispose();
            }
        }
    }
}
