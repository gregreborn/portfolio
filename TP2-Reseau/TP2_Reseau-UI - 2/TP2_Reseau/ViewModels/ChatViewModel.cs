using System.Collections.ObjectModel;
using TP2_Reseau.Models;
using TP2_Reseau.Services;
using ReactiveUI;
using System;
using System.Collections.Generic;
using System.Reactive;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using TP2_Reseau.Encryption;
using TP2_Reseau.Messaging;

namespace TP2_Reseau.ViewModels
{
    public class ChatViewModel : ViewModelBase
    {
        private ObservableCollection<PeerInfo> _peers; // List of peers
        private ObservableCollection<MessageModel> _messages;
        private readonly EncryptionService _encryptionService;
        private string _currentEncryptionKey; // Variable to store the current encryption key

        private string _currentMessage;
        private string _peerAddress; // Peer address to send messages to
        private readonly ChatService _chatService; // Chat service to send messages
        private string _serverPort = "8088"; // Default port number
        private PeerInfo _selectedPeer;

        public ChatViewModel()
        {
            _encryptionService = new EncryptionService();
            _currentEncryptionKey = GenerateKey(); // Implement this method to retrieve the stored key

            _chatService = new ChatService(_encryptionService, _currentEncryptionKey);
            _messages = new ObservableCollection<MessageModel>();
            _peers = new ObservableCollection<PeerInfo>();
            FetchPeersCommand = ReactiveCommand.CreateFromTask(FetchPeersAsync);
            SendMessageCommand = ReactiveCommand.CreateFromTask(SendMessageAsync);
            ConnectCommand = ReactiveCommand.CreateFromTask(ConnectAsync);

            // Subscribe to the MessageReceived event of the ChatService
            _chatService.MessageReceived += ReceiveMessage;
        }


        
        public ObservableCollection<PeerInfo> Peers
        {
            get => _peers;
            set => this.RaiseAndSetIfChanged(ref _peers, value);
        }
        public string ServerPort
        {
            get => _serverPort;
            set => this.RaiseAndSetIfChanged(ref _serverPort, value);
        }

        public ObservableCollection<MessageModel> Messages
        {
            get => _messages;
            set => this.RaiseAndSetIfChanged(ref _messages, value);
        }

        public string CurrentMessage
        {
            get => _currentMessage;
            set => this.RaiseAndSetIfChanged(ref _currentMessage, value);
        }

        public string PeerAddress
        {
            get => _peerAddress;
            set => this.RaiseAndSetIfChanged(ref _peerAddress, value);
        }
        public PeerInfo SelectedPeer
        {
            get => _selectedPeer;
            set
            {
                this.RaiseAndSetIfChanged(ref _selectedPeer, value);
                PeerAddress = value?.Id; // Automatically update PeerAddress
            }
        }

        public ReactiveCommand<Unit, Unit> SendMessageCommand { get; }
        public ReactiveCommand<Unit, Unit> ConnectCommand { get; }
        public ReactiveCommand<Unit, Unit> FetchPeersCommand { get; }
        

        private async Task FetchPeersAsync()
        {
            try
            {
                var peers = await _chatService.FetchPeersAsync($"http://localhost:{ServerPort}");
                Peers.Clear();
                foreach (var peer in peers.Values)
                {
                    if (peer.Id != "uuid2") // Exclude self
                    {
                        if (!string.IsNullOrEmpty(peer.tcp_address))
                        {
                            // Create a new PeerInfo instance for TCP
                            var peerTcp = new PeerInfo
                            {
                                Id = peer.Id,
                                Address = peer.tcp_address,
                                DisplayText = $"{peer.Id} {peer.tcp_address}: TCP"
                            };
                            Peers.Add(peerTcp);
                        }
                
                        if (!string.IsNullOrEmpty(peer.udp_address))
                        {
                            // Create a new PeerInfo instance for UDP
                            var peerUdp = new PeerInfo
                            {
                                Id = peer.Id,
                                Address = peer.udp_address,
                                DisplayText = $"{peer.Id} {peer.udp_address}: UDP"
                            };
                            Peers.Add(peerUdp);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle errors (e.g., display an error message)
                Console.WriteLine($"Failed to fetch peers: {ex.Message}");
            }
        }


        private async Task SendMessageAsync()
        {
            if (!string.IsNullOrWhiteSpace(CurrentMessage) && SelectedPeer != null)
            {
                // Extract the protocol from the DisplayText
                string protocol = SelectedPeer.DisplayText.EndsWith("TCP") ? "tcp" : "udp";
        
                // Encrypt the content of the message
                var encryptedContent = _encryptionService.Encrypt(CurrentMessage, _currentEncryptionKey);

                // Create a TLV object with the recipient's UUID, the encrypted content, and the protocol
                var tlv = new TLV
                {
                    Type = "chat",
                    Length = Encoding.UTF8.GetByteCount(encryptedContent),
                    Value = encryptedContent,
                    RecipientID = SelectedPeer.Id, // Assign the recipient's UUID here
                    Protocol = protocol
                };

                // Include the recipient's UUID in the TLVPacket, but outside the encrypted content
                var tlvPacket = new TLVPacket
                {
                    Tlv = new List<TLV> { tlv },
                };
                var tlvPacketJson = JsonSerializer.Serialize(tlvPacket);

                // Send the TLV formatted message using the ChatService
                await _chatService.SendMessageAsync(tlvPacketJson);

                // Add the message to the UI messages list with the original, unencrypted content for display
                var newMessage = new MessageModel(
                    senderId: "uuid2",
                    recipientId: SelectedPeer.Id,
                    content: CurrentMessage,
                    timestamp: DateTime.Now
                );

                Messages.Add(newMessage);
                CurrentMessage = string.Empty;
            }
        }






        private void ReceiveMessage(MessageModel message)
        {
            Messages.Add(message);
        }

        private async Task ConnectAsync()
        {
            try
            {
                await _chatService.ConnectAsync($"ws://localhost:{ServerPort}/ws");

                // Send a registration message with the peer ID
                var registrationMessage = new
                {
                    type = "register",
                    peerID = "uuid2" // Replace with the actual peer ID
                };
                string registrationMessageJson = JsonSerializer.Serialize(registrationMessage);
                await _chatService.SendMessageAsync(registrationMessageJson);

                // Fetch peers after successful connection to display their protocol preferences
                await FetchPeersAsync();
            }
            catch (Exception ex)
            {
                // Handle connection failure
                Console.WriteLine($"Failed to connect: {ex.Message}");
            }
        }

        private string GenerateKey()
        {
            // Replace with your actual Base-64 encoded key
            return "Wk/l9V2dOx5eDaVBawdHwO8F7rqSR841mweRAz6oLow=\n";
        }



    }
}
