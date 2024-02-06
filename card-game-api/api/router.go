package api

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func NewRouter(h *Handler) *mux.Router {
	r := mux.NewRouter()
	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Println("Serving index.html")
		http.ServeFile(w, r, "index.html")
	}).Methods("GET")

	r.HandleFunc("/deck/custom", func(w http.ResponseWriter, r *http.Request) {
		log.Println("Serving custom_deck.html")
		http.ServeFile(w, r, "custom_deck.html")
	}).Methods("GET")

	r.HandleFunc("/deck/draw", func(w http.ResponseWriter, r *http.Request) {
		log.Println("Serving draw_deck.html")
		http.ServeFile(w, r, "draw_deck.html")
	}).Methods("GET")

	r.HandleFunc("/deck/shuffle", func(w http.ResponseWriter, r *http.Request) {
		log.Println("Serving shuffle_deck.html")
		http.ServeFile(w, r, "shuffle_deck.html")
	}).Methods("GET")

	r.HandleFunc("/deck/{deckid}/add", h.addCardsToDeckHandler).Methods("POST")
	r.HandleFunc("/deck/new", h.initializeDeckHandler).Methods("POST")
	r.HandleFunc("/deck/shuffle/{deckid}", h.shuffleDeckHandler).Methods("GET")
	r.HandleFunc("/deck/{deckid}/draw/{nbrCarte}", h.drawCardHandler).Methods("GET")
	r.HandleFunc("/static/fronts/{svgName}.svg", ServeCardImage).Methods("GET")
	return r
}
