package main

import (
	"TP2_Reseau_Server/internal/peer"
	"TP2_Reseau_Server/network"
	"flag"
	"fmt"
	"log"
	"path/filepath"
	"time"
)

func main() {
	portPtr := flag.String("port", "8085", "WebSocket port")
	tcpPortPtr := flag.String("tcpPort", "8081", "TCP server port")
	udpPortPtr := flag.String("udpPort", "8082", "UDP server port")
	uuidPtr := flag.String("uuid", "", "UUID of the peer")

	flag.Parse()

	if *uuidPtr == "" {
		panic("UUID must be provided with --uuid flag")
	}

	// Initialize and populate peerList before using it
	peerList := peer.NewPeerList()
	configPath := filepath.Join("internal", "peer", "peers.json")
	if err := peerList.DiscoverPeers(configPath); err != nil {
		log.Fatalf("Failed to discover peers: %v", err)
	}

	// Now pass the peerList to NewServer
	server := network.NewServer(*portPtr, *tcpPortPtr, *udpPortPtr, *uuidPtr, peerList)
	go server.Start()

	myPeer := peer.NewPeer(*uuidPtr, fmt.Sprintf("localhost:%s", *tcpPortPtr))
	myPeer.PeerList = peerList

	// Always listening for incoming messages
	go myPeer.HandleIncomingMessages()

	go sendPeriodicHelloMessages(peerList)

	select {} // Keep the server running
}

func sendPeriodicHelloMessages(peerList *peer.PeerList) {
	ticker := time.NewTicker(1 * time.Minute)
	defer ticker.Stop()

	for {
		<-ticker.C
		for _, p := range peerList.Peers {
			// Ensure connection is established before sending message
			if p.Conn == nil {
				err := p.ConnectToPeerTCP(p.Address)
				if err != nil {
					log.Printf("Failed to connect to peer %s: %v", p.ID, err)
					continue
				}
			}

			err := p.SendHelloMessage()
			if err != nil {
				log.Printf("Failed to send Hello message to %s: %v", p.ID, err)
			} else {
				log.Printf("Hello message sent to %s", p.ID)
			}
		}
	}
}
