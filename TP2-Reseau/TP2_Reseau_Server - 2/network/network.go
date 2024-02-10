package network

import (
	"TP2_Reseau_Server/internal/peer"
	"encoding/json"
	"fmt"
	"github.com/gorilla/websocket"
	"io"
	"log"
	"net"
	"net/http"
)

type Server struct {
	Port          string
	TcpPort       string
	UdpPort       string
	serverPeerID  string // Add this field to store the server's own peer ID
	peerList      *peer.PeerList
	uiConnections map[string]*websocket.Conn
}

// Initialize peerList in NewServer

func NewServer(port, tcpPort, udpPort, serverPeerID string, peerList *peer.PeerList) *Server {
	return &Server{
		Port:          port,
		TcpPort:       tcpPort,
		UdpPort:       udpPort,
		peerList:      peerList, // Set the server's peerList field to the provided peerList
		serverPeerID:  serverPeerID,
		uiConnections: make(map[string]*websocket.Conn),
	}
}

// Start initializes and starts the server
func (s *Server) Start() {
	// Start TCP server
	go func() {
		if err := s.StartTCPServer(s.TcpPort); err != nil {
			log.Printf("Failed to start TCP server: %v", err)
		}
	}()

	// Start UDP server
	go func() {
		if err := s.StartUDPServer(s.UdpPort); err != nil {
			log.Printf("Failed to start UDP server: %v", err)
		}
	}()

	// Start WebSocket server
	http.HandleFunc("/ws", handleWebSocket(s.peerList))

	// Register handler for serving peer list
	http.HandleFunc("/peers", handlePeers(s.peerList))

	// Start the HTTP server
	log.Printf("Server starting on port %s", s.Port)
	if err := http.ListenAndServe(":"+s.Port, nil); err != nil {
		log.Fatal("HTTP server ListenAndServe: ", err)
	}
}
func handlePeers(peerList *peer.PeerList) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		peersJSON, err := peerList.GetPeersJSON()
		if err != nil {
			log.Printf("Error generating peers JSON: %v", err)
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
			return
		}
		log.Println("Sending peers JSON:", peersJSON)
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte(peersJSON))
	}
}

// StartTCPServer starts a TCP server on a specified port
func (s *Server) StartTCPServer(port string) error {
	listener, err := net.Listen("tcp", ":"+port)
	if err != nil {
		log.Printf("Error starting TCP server: %v", err)
		return err
	}
	defer listener.Close()
	log.Printf("TCP server started on port %s", port)

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Printf("Error accepting TCP connection: %v", err)
			continue
		}
		go s.handleConnection(conn) // handle each connection concurrently
	}
}

// StartUDPServer starts a UDP server on a specified port
func (s *Server) StartUDPServer(port string) error {
	addr, err := net.ResolveUDPAddr("udp", ":"+port)
	if err != nil {
		log.Printf("Error resolving UDP address: %v", err)
		return err
	}

	conn, err := net.ListenUDP("udp", addr)
	if err != nil {
		log.Printf("Error starting UDP server: %v", err)
		return err
	}
	defer conn.Close()
	log.Printf("UDP server started on port %s", port)

	// Buffer for reading incoming data
	buffer := make([]byte, 1024)
	for {
		n, addr, err := conn.ReadFromUDP(buffer)
		if err != nil {
			log.Printf("Error reading UDP data: %v", err)
			continue
		}

		// Handle UDP-specific logic here
		rawMessage := buffer[:n]

		// Deserialize the UDP message and process it accordingly
		var msg peer.Message
		if err := json.Unmarshal(rawMessage, &msg); err != nil {
			log.Printf("Error unmarshalling UDP message: %v", err)
			continue
		}

		log.Printf("Received UDP message from %s: %s", addr, string(rawMessage))
		go s.handleUDPConnection(rawMessage) // handle each connection concurrently

	}
}

func (s *Server) handleConnection(conn net.Conn) {
	defer conn.Close()

	buffer := make([]byte, 1024)
	for {
		n, err := conn.Read(buffer)
		if err != nil {
			if err != io.EOF {
				log.Printf("Error reading from connection: %v", err)
			}
			break
		}

		rawMessage := buffer[:n]
		var msg peer.Message
		if err := json.Unmarshal(rawMessage, &msg); err != nil {
			log.Printf("Error unmarshalling message: %v", err)
			continue
		}

		// Check if message is for this server
		if len(msg.TLV) > 0 && msg.TLV[0].RecipientID == s.serverPeerID {
			if msg.TLV[0].Protocol == "tcp" {
				s.handleTCPConnection(rawMessage)
			} else {
				log.Printf("Unknown message protocol: %s", msg.TLV[0].Protocol)
			}
		} else {
			if err := s.forwardRawMessageToPeer(rawMessage); err != nil {
				log.Printf("Error forwarding raw message: %v", err)
			}
		}
	}
}

func (s *Server) handleTCPConnection(rawMessage []byte) {
	// Handle TCP-specific logic here
	var msg peer.Message
	if err := json.Unmarshal(rawMessage, &msg); err != nil {
		log.Printf("Error unmarshalling TCP message: %v", err)
		return
	}

	// Check the TLV for the "protocol" field to ensure it's TCP
	if len(msg.TLV) > 0 && msg.TLV[0].Protocol == "tcp" {
		if err := s.sendToUI(rawMessage, msg.TLV[0].RecipientID); err != nil {
			log.Printf("Error sending message to UI: %v", err)
		}
	} else {
		log.Printf("Invalid or missing TCP protocol in the message")
	}
}

func (s *Server) handleUDPConnection(rawMessage []byte) {

	// Deserialize the UDP message
	var msg peer.Message
	if err := json.Unmarshal(rawMessage, &msg); err != nil {
		log.Printf("Error unmarshalling UDP message: %v", err)
		return
	}

	if len(msg.TLV) > 0 && msg.TLV[0].Protocol == "udp" {
		if err := s.sendToUI(rawMessage, msg.TLV[0].RecipientID); err != nil {
			log.Printf("Error sending message to UI: %v", err)
		}
	} else {
		log.Printf("Invalid or missing TCP protocol in the message")
	}
}

func (s *Server) sendToUI(rawMessage []byte, recipientID string) error {
	uiConn, exists := uiConnections[recipientID]
	if !exists {
		return fmt.Errorf("UI connection for recipient ID %s not found", recipientID)
	}

	// Send the message to the UI client over WebSocket
	if err := uiConn.WriteMessage(websocket.TextMessage, rawMessage); err != nil {
		return fmt.Errorf("error sending message to UI: %v", err)
	}
	return nil
}

func (s *Server) getUIConnection(recipientID string) (*websocket.Conn, bool) {
	// Implement this method to return the WebSocket connection for a given recipient ID.
	// This is a pseudo-code example:
	uiConn, exists := s.uiConnections[recipientID]
	return uiConn, exists
}

func (s *Server) forwardRawMessageToPeer(rawMessage []byte) error {
	var msg peer.Message
	if err := json.Unmarshal(rawMessage, &msg); err != nil {
		return err // Handle unmarshalling error
	}

	// Assuming each TLV might have a RecipientID
	for _, tlv := range msg.TLV {
		if tlv.RecipientID != "" {
			recipientPeer, exists := s.peerList.GetPeer(tlv.RecipientID)
			if !exists {
				return fmt.Errorf("recipient with ID %s not found", tlv.RecipientID)
			}
			// Forward the message as is
			if err := recipientPeer.SendMessage(&msg); err != nil {
				return err
			}
			break
		}
	}
	return nil
}

// Server implements the PeerListHandler interface
func (s *Server) GetPeer(uuid string) (*peer.Peer, bool) {
	return s.peerList.GetPeer(uuid)
}

func (s *Server) UpdatePeerCryptoSalt(uuid string, salt string) {
	if peer, exists := s.peerList.GetPeer(uuid); exists {
		peer.UpdateCryptoSalt(salt)
	}
}

func (s *Server) sendUDPMessage(targetPeer *peer.Peer, msg *peer.Message) error {
	// Serialize the message
	msgBytes, err := json.Marshal(msg)
	if err != nil {
		return err
	}

	// Resolve UDP address and send the message
	udpAddr, err := net.ResolveUDPAddr("udp", targetPeer.Address)
	if err != nil {
		return err
	}

	conn, err := net.DialUDP("udp", nil, udpAddr)
	if err != nil {
		return err
	}
	defer conn.Close()

	_, err = conn.Write(msgBytes)
	return err
}

func processLocalMessage(message string, peerList *peer.PeerList) {
	// Process the message locally
	// This could involve various actions depending on your application's logic
	log.Printf("Processing local message: %s", message)
}

// Implement extractPeerIDFromMessage according to your message format
