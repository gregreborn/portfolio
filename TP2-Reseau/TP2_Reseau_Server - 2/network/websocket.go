package network

import (
	"TP2_Reseau_Server/internal/peer"
	"encoding/json"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var uiConnections = make(map[string]*websocket.Conn)

func handleWebSocket(peerList *peer.PeerList) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		conn, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			log.Println("Upgrade:", err)
			return
		}
		defer conn.Close()

		log.Println("WebSocket connection established")

		for {
			_, msgBytes, err := conn.ReadMessage()
			if err != nil {
				log.Println("Read:", err)
				break
			}

			// Unmarshal into a generic map to check message type
			var msg map[string]interface{}
			if err := json.Unmarshal(msgBytes, &msg); err != nil {
				log.Println("Unmarshal:", err)
				continue
			}

			// Check for registration message
			if msgType, ok := msg["type"].(string); ok && msgType == "register" {
				if peerID, ok := msg["peerID"].(string); ok {
					uiConnections[peerID] = conn
					log.Printf("Associated peer ID %s with a WebSocket connection", peerID)
				}
			} else {
				// Handle other message types by dispatching to processing functions
				peer.ProcessMessage(conn, msgBytes, peerList)
			}
		}
	}
}
