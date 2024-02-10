using System;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace TP2_Reseau.Services
{
    public class WebSocketService : IDisposable
    {
        private ClientWebSocket _webSocket;
        private readonly string _serverUri;
        private readonly CancellationTokenSource _cancellationTokenSource = new CancellationTokenSource();

        public event EventHandler<MessageReceivedEventArgs> MessageReceived;
        public event EventHandler<EventArgs> Connected;
        public event EventHandler<EventArgs> Disconnected;

        public WebSocketService(string serverUri)
        {
            _serverUri = serverUri;
            _webSocket = new ClientWebSocket();
        }

        public WebSocketState State => _webSocket?.State ?? WebSocketState.None;

        // Connect to the WebSocket server
        public async Task ConnectAsync()
        {
            try
            {
                await _webSocket.ConnectAsync(new Uri(_serverUri), _cancellationTokenSource.Token);
                Connected?.Invoke(this, EventArgs.Empty);
                StartListening();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"WebSocket connection failed: {ex.Message}");
            }
        }

        // Send a message to the server
        public async Task SendMessageAsync(string message)
        {
            if (_webSocket.State != WebSocketState.Open)
            {
                throw new InvalidOperationException("WebSocket is not connected.");
            }

            var messageBuffer = Encoding.UTF8.GetBytes(message);
            var segment = new ArraySegment<byte>(messageBuffer);

            await _webSocket.SendAsync(segment, WebSocketMessageType.Text, true, CancellationToken.None);
        }


        // Close the WebSocket connection
        public async Task CloseAsync()
        {
            if (_webSocket.State == WebSocketState.Open)
            {
                await _webSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, "Closing", _cancellationTokenSource.Token);
                Disconnected?.Invoke(this, EventArgs.Empty);
            }

            Dispose();
        }

        // Start listening for messages from the server
        private async void StartListening()
        {
            var buffer = new ArraySegment<byte>(new byte[2048]);

            try
            {
                while (_webSocket.State == WebSocketState.Open)
                {
                    var result = await _webSocket.ReceiveAsync(buffer, _cancellationTokenSource.Token);

                    if (result.MessageType == WebSocketMessageType.Close)
                    {
                        await CloseAsync();
                    }
                    else
                    {
                        var messageString = Encoding.UTF8.GetString(buffer.Array, 0, result.Count);
                        MessageReceived?.Invoke(this, new MessageReceivedEventArgs(messageString));
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"WebSocket listening error: {ex.Message}");
            }
        }

        // Custom EventArgs to handle incoming messages
        public class MessageReceivedEventArgs : EventArgs
        {
            public string Message { get; }

            public MessageReceivedEventArgs(string message)
            {
                Message = message;
            }
        }

        public void Dispose()
        {
            _cancellationTokenSource.Cancel();

            if (_webSocket != null)
            {
                _webSocket.Dispose();
                _webSocket = null;
            }
        }
        
        
    }
}
