package peer

import (
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"os"
	"sync"
	"time"

	"github.com/gorilla/websocket"
)

type ChatMessage struct {
	From    string `json:"from"`
	Content string `json:"content"`
}

type Peer struct {
	ID                   string   `json:"id"`
	Address              string   `json:"address"`
	Conn                 net.Conn `json:"-"`
	PublicKey            string   `json:"publicKey"` // Field to store the public key
	PeerList             *PeerList
	TCPEndPoint          string `json:"tcp_address"`
	UDPEndPoint          string `json:"udp_address"`
	PreferredProtocol    string `json:"preferredProtocol"`
	CryptoSalt           string
	OtherPeersPublicKeys map[string]string
	Protocol             string // TCP or UDP
}

type PeerList struct {
	Peers map[string]*Peer `json:""`
	mux   sync.RWMutex     // Mutex peersfor concurrent access to the Peers map
}

func NewPeerList() *PeerList {
	return &PeerList{
		Peers: make(map[string]*Peer),
	}
}

func NewPeer(id string, address string) *Peer {
	return &Peer{
		ID:                   id,
		Address:              address,
		OtherPeersPublicKeys: make(map[string]string), // Initialize the map
	}
}

func (pl *PeerList) AddPeer(peer *Peer) {
	pl.mux.Lock()
	defer pl.mux.Unlock()
	pl.Peers[peer.ID] = peer
	log.Printf("Peer added: %v", peer.ID)
}

func (pl *PeerList) RemovePeer(peerID string) {
	pl.mux.Lock()
	defer pl.mux.Unlock()
	delete(pl.Peers, peerID)
}

func (pl *PeerList) GetPeer(peerID string) (*Peer, bool) {
	pl.mux.RLock()
	defer pl.mux.RUnlock()
	peer, exists := pl.Peers[peerID]
	return peer, exists
}

func (pl *PeerList) DiscoverPeers(configFilePath string) error {
	data, err := os.ReadFile(configFilePath)
	if err != nil {
		log.Printf("Error reading config file: %v", err)
		return err
	}
	err = json.Unmarshal(data, pl)
	if err != nil {
		log.Printf("Error unmarshalling peer list: %v", err)
		return err
	}
	log.Printf("Peer list loaded: %+v", pl.Peers)
	return nil
}

func (pl *PeerList) SavePeers(configFilePath string) error {
	pl.mux.RLock()
	defer pl.mux.RUnlock()
	data, err := json.MarshalIndent(pl, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(configFilePath, data, 0644)
}

func (p *Peer) ConnectToPeerTCP(address string) error {
	var err error
	p.Conn, err = net.Dial("tcp", address)
	if err != nil {
		log.Printf("Failed to connect to peer at %s: %v", address, err)
		return err
	}
	log.Printf("Successfully connected to peer at %s", address)
	return nil
}

// SendMessage sends a message to the connected peer
func (p *Peer) SendMessage(msg *Message) error {
	if p.Conn == nil {
		return fmt.Errorf("no connection established")
	}
	msgBytes, err := json.Marshal(msg)
	if err != nil {
		return err
	}
	log.Printf("Sending message to peer: %s", string(msgBytes))
	_, err = p.Conn.Write(msgBytes)
	if err != nil {
		log.Printf("Failed to send message to peer: %v", err)
	}
	return err
}

func (p *Peer) SendUDPChatMessage(msg *Message, recipientPeer *Peer) error {
	// Serialize the message
	msgBytes, err := json.Marshal(msg)
	if err != nil {
		log.Printf("Error marshaling message: %v", err)
		return err
	}

	udpAddr, err := net.ResolveUDPAddr("udp", recipientPeer.UDPEndPoint)
	if err != nil {
		log.Printf("Error resolving UDP address: %v", err)
		return err
	}

	// Use an existing UDP connection if available
	var conn *net.UDPConn
	if p.Conn != nil {
		var ok bool
		conn, ok = p.Conn.(*net.UDPConn)
		if !ok {
			return fmt.Errorf("existing connection is not UDP")
		}
	} else {
		conn, err = net.ListenUDP("udp", nil)
		if err != nil {
			log.Printf("Error listening on UDP: %v", err)
			return err
		}
		defer conn.Close()
	}

	_, err = conn.WriteToUDP(msgBytes, udpAddr)
	if err != nil {
		log.Printf("Error sending UDP message: %v", err)
	} else {
		log.Printf("UDP message sent to %s", recipientPeer.ID)
	}
	return err
}

func (p *Peer) SendHelloMessage() error {
	// Generate or retrieve your public key
	publicKey := "SamplePublicKey"

	// Construct the Hello message
	helloMsg := HelloMessage{
		UUID: p.ID,
		Key:  publicKey,
	}
	helloMsgBytes, err := json.Marshal(helloMsg)
	if err != nil {
		return err
	}

	// Construct the TLV for Hello message
	tlv := TLV{
		Type:   "hello",
		Length: len(helloMsgBytes),
		Value:  string(helloMsgBytes),
	}

	msg := Message{
		TLV: []TLV{tlv},
	}

	return p.SendMessage(&msg)
}

// HandleIncomingMessages updated to handle chat messages
func (p *Peer) HandleIncomingMessages() {
	if p.Conn == nil {
		log.Println("Connection is not established, waiting for connection...")
		for p.Conn == nil {
			time.Sleep(1 * time.Second)
		}
	}

	log.Println("Connection established, listening for incoming messages...")
	buffer := make([]byte, 1024)
	for {
		n, err := p.Conn.Read(buffer)
		if err != nil {
			log.Printf("Read error: %v\n", err)
			break
		}
		log.Printf("Received message: %s", string(buffer[:n]))

		var msg Message
		err = json.Unmarshal(buffer[:n], &msg)
		if err != nil {
			log.Printf("Unmarshal error: %v\n", err)
			continue
		}

		for _, tlv := range msg.TLV {
			switch tlv.Type {
			case "chat":
				var chatMsg ChatMessage
				if err := json.Unmarshal([]byte(tlv.Value), &chatMsg); err != nil {
					log.Printf("Error unmarshalling chat message: %v\n", err)
					continue
				}
				log.Printf("Chat message received from %s: %s\n", chatMsg.From, chatMsg.Content)
			case "hello":
				var helloMsg HelloMessage
				if err := json.Unmarshal([]byte(tlv.Value), &helloMsg); err != nil {
					log.Printf("Error unmarshalling hello message: %v\n", err)
					continue
				}
				p.UpdatePublicKey(helloMsg.Key)
				log.Printf("Updated public key for %s: %s\n", p.ID, helloMsg.Key)
			}
		}
	}
}

func (p *Peer) SendChatMessage(toUUID, content string) error {
	chatMsg := ChatMessage{
		From:    p.ID,
		Content: content,
	}
	chatMsgBytes, err := json.Marshal(chatMsg)
	if err != nil {
		return err
	}

	// Construct a Message with the serialized chat message
	msg := Message{
		TLV: []TLV{{
			Type:   "chat",
			Length: len(chatMsgBytes),
			Value:  string(chatMsgBytes),
		}},
	}

	return p.SendMessage(&msg)
}

// UpdatePublicKey updates the public key for the peer
func (p *Peer) UpdatePublicKey(key string) {
	p.PublicKey = key
}

func (p *Peer) UpdateCryptoSalt(salt string) {
	p.CryptoSalt = salt
}

type TLV struct {
	Type        string `json:"type"`
	Length      int    `json:"length"`
	Value       string `json:"value"`
	RecipientID string `json:"recipientId,omitempty"`
	Protocol    string `json:"protocol,omitempty"` // Add the protocol field
}

type Message struct {
	TLV []TLV `json:"tlv"`
}

// MessageModel represents the structure of a chat message.
type MessageModel struct {
	SenderId    string `json:"senderId"`
	RecipientID string `json:"recipientID"`
	Content     string `json:"content"`
	Timestamp   string `json:"timestamp"`
}

type HelloMessage struct {
	UUID string `json:"uuid"`
	Key  string `json:"key"` // Public key or other identifier
}

// ParseMessage parses a raw JSON message into a Message struct
func ParseMessage(msgBytes []byte) (*Message, error) {
	var msg Message
	err := json.Unmarshal(msgBytes, &msg)
	return &msg, err
}

// ProcessMessage processes incoming WebSocket messages
func ProcessMessage(conn *websocket.Conn, msgBytes []byte, peerList *PeerList) {
	msg, err := ParseMessage(msgBytes)
	if err != nil {
		log.Printf("Error parsing message: %v", err)
		return
	}

	for _, tlv := range msg.TLV {
		switch tlv.Type {
		case "chat":
			// Assuming that 'protocol' is a string field in your TLV struct
			if tlv.Protocol == "tcp" {
				processTCPMessage(conn, &tlv, peerList)
			} else if tlv.Protocol == "udp" {
				processUDPMessage(conn, &tlv, peerList)

			} else {
				log.Printf("Unknown protocol in chat message TLV")
			}
		case "hello":
			processHelloMessage(conn, &tlv, peerList)
		default:
			log.Printf("Unknown TLV type: %s", tlv.Type)
		}
	}

}

func processTCPMessage(conn *websocket.Conn, tlv *TLV, peerList *PeerList) {
	log.Printf("Received chat message: %s", tlv.Value)

	recipientPeer, exists := peerList.GetPeer(tlv.RecipientID)
	if !exists {
		log.Printf("Recipient UUID not found in peer list")
		return
	}

	// Check if connection with the recipient is established
	if recipientPeer.Conn == nil {
		err := recipientPeer.ConnectToPeerTCP(recipientPeer.TCPEndPoint)
		if err != nil {
			log.Printf("Failed to connect to recipient peer %s: %v", recipientPeer.ID, err)
			return
		}
	}

	// Forward the message to the intended recipient
	if err := recipientPeer.SendMessage(&Message{TLV: []TLV{*tlv}}); err != nil {
		log.Printf("Error forwarding message to recipient: %v", err)
	} else {
		log.Printf("Chat message sent to %s", recipientPeer.ID)
	}
}

// New function to handle UDP chat messages
func processUDPMessage(conn *websocket.Conn, tlv *TLV, peerList *PeerList) {
	log.Printf("Received chat message: %s", tlv.Value)

	recipientPeer, exists := peerList.GetPeer(tlv.RecipientID)
	if !exists {
		log.Printf("Recipient UUID not found in peer list")
		return
	}

	// Forward the message to the intended recipient
	if err := recipientPeer.SendUDPChatMessage(&Message{TLV: []TLV{*tlv}}, recipientPeer); err != nil {
		log.Printf("Error forwarding message to recipient: %v", err)
	} else {
		log.Printf("Chat message sent to %s", recipientPeer.ID)
	}

}

func hashSHA256(input, salt string) string {
	hasher := sha256.New()
	hasher.Write([]byte(input + salt)) // Combine input and salt
	return hex.EncodeToString(hasher.Sum(nil))
}

func processHelloMessage(conn *websocket.Conn, tlv *TLV, peerList *PeerList) {
	var helloMsg HelloMessage
	err := json.Unmarshal([]byte(tlv.Value), &helloMsg)
	if err != nil {
		log.Printf("Error unmarshalling hello message content: %v", err)
		return
	}
	// Generate a unique cryptographic salt for this peer
	salt, err := generateUniqueSalt()
	if err != nil {
		log.Printf("Error generating salt: %v", err)
		return
	}
	log.Printf("Received hello message with key: %s, sending back salt: %s", helloMsg.Key, salt)
	// Store the public key and update the cryptographic salt
	peer, exists := peerList.GetPeer(helloMsg.UUID)
	if exists {
		peer.OtherPeersPublicKeys[helloMsg.UUID] = helloMsg.Key
		log.Printf("Updating cryptographic salt for peer %s to %s", helloMsg.UUID, salt)
		peer.UpdateCryptoSalt(salt)
	}

	responseTLV := TLV{
		Type:   "hello-response",
		Length: len(salt),
		Value:  salt,
	}
	response := Message{TLV: []TLV{responseTLV}}
	responseJSON, err := json.Marshal(response)
	if err != nil {
		log.Printf("Error marshaling hello response: %v", err)
		return
	}
	if err := conn.WriteMessage(websocket.TextMessage, responseJSON); err != nil {
		log.Printf("Error sending hello response: %v", err)
	}
}

func generateUniqueSalt() (string, error) {
	b := make([]byte, 16) // 16 bytes = 128 bits of randomness, adjust size as needed
	_, err := rand.Read(b)
	if err != nil {
		return "", err
	}
	return base64.StdEncoding.EncodeToString(b), nil
}

func (pl *PeerList) GetPeersJSON() (string, error) {
	pl.mux.RLock()
	defer pl.mux.RUnlock()
	data, err := json.Marshal(pl.Peers)
	if err != nil {
		return "", err
	}
	log.Println("Generated JSON for peers:", string(data))
	return string(data), nil
}
