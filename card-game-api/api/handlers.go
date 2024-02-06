package api

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"path"
	"strconv"
	"strings"

	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"github.com/gregreborn/Gregory-reseau/Devoir/card-game-api/model"
)

type Handler struct {
	DBCh chan model.DBRequest
}

func (h *Handler) shuffleDeckHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	deckID := vars["deckid"]

	ch := make(chan model.DBResponse)
	h.DBCh <- model.DBRequest{
		Action:     model.ActionShuffleDeck,
		DeckID:     deckID,
		ResponseCh: ch,
	}
	res := <-ch
	if res.Error != nil {
		httpError(w, "Error shuffling deck in the database", http.StatusInternalServerError)
		return
	}

	jsonResponse(w, map[string]interface{}{
		"deck_id": deckID,
		"message": "Deck shuffled successfully!",
	})
}

func (h *Handler) initializeDeckHandler(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	nbrPaquet, exists := vars["nbrPaquet"]
	if !exists {
		nbrPaquet = "1"
	}

	nbr, err := strconv.Atoi(nbrPaquet)
	if err != nil {
		httpError(w, "Invalid number of decks provided", http.StatusBadRequest)
		return
	}

	deck := generateDeck(nbr)

	deckID := uuid.New().String()
	ch := make(chan model.DBResponse)
	h.DBCh <- model.DBRequest{
		Action:     model.ActionCreateDeck,
		DeckID:     deckID,
		CardsStr:   strings.Join(deck, ","),
		ResponseCh: ch,
	}
	res := <-ch

	if res.Error != nil {
		httpError(w, "Error creating deck in the database:", http.StatusBadRequest)
		return
	}

	jsonResponse(w, map[string]interface{}{
		"deck_id":   deckID,
		"remaining": len(deck),
	})
}

func (h *Handler) addCardsToDeckHandler(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	deckID, exists := vars["deckid"]

	if !exists {
		httpError(w, "DeckID not provided", http.StatusBadRequest)
		return
	}

	r.ParseForm()
	cardsToAddStr := r.PostFormValue("cardsToAdd")
	if cardsToAddStr == "" {
		httpError(w, "No cards provided to add", http.StatusBadRequest)
		return
	}

	ch := make(chan model.DBResponse)
	h.DBCh <- model.DBRequest{
		Action:     model.ActionGetDeck,
		DeckID:     deckID,
		ResponseCh: ch,
	}
	res := <-ch
	if res.Error != nil {
		httpError(w, "Error fetching deck from the database", http.StatusInternalServerError)
		return
	}

	newCards := strings.Split(cardsToAddStr, ",")
	existingCards := strings.Split(res.CardsStr, ",")
	allCards := append(newCards, existingCards...)

	chAdd := make(chan model.DBResponse)
	h.DBCh <- model.DBRequest{
		Action:     model.ActionAddCardsToDeck,
		DeckID:     deckID,
		CardsStr:   strings.Join(allCards, ","),
		ResponseCh: chAdd,
	}
	resAdd := <-chAdd
	if resAdd.Error != nil {
		httpError(w, "Error adding cards to the deck in the database", http.StatusInternalServerError)
		return
	}

	chUpdated := make(chan model.DBResponse)
	h.DBCh <- model.DBRequest{
		Action:     model.ActionGetDeck,
		DeckID:     deckID,
		ResponseCh: chUpdated,
	}
	resUpdated := <-chUpdated
	if resUpdated.Error != nil {
		httpError(w, "Error fetching the updated deck from the database", http.StatusInternalServerError)
		return
	}

	remaining := len(allCards)

	jsonResponse(w, map[string]interface{}{
		"deck_id":   deckID,
		"remaining": remaining,
		"message":   fmt.Sprintf("Successfully added cards to deck %s. Total cards now: %d", deckID, remaining),
	})
}

func jsonResponse(w http.ResponseWriter, data map[string]interface{}) {
	response, _ := json.Marshal(data)
	w.Header().Set("Content-Type", "application/json")
	w.Write(response)
}

func generateDeck(nbr int) []string {
	suits := []string{"clubs", "diamonds", "hearts", "spades"}
	ranks := []string{"2", "3", "4", "5", "6", "7", "8", "9", "10", "ace", "jack", "king", "queen"}
	jokers := []string{"joker_black", "joker_red"}

	var deck []string
	for _, suit := range suits {
		for _, rank := range ranks {
			deck = append(deck, suit+"_"+rank)
		}
	}
	deck = append(deck, jokers...)

	finalDeck := []string{}
	for i := 0; i < nbr; i++ {
		finalDeck = append(finalDeck, deck...)
	}
	return finalDeck
}

func (h *Handler) drawCardHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	deckID := vars["deckid"]

	nbrCarteStr, exists := vars["nbrCarte"]
	if !exists {
		nbrCarteStr = "1"
	}

	nbrCarte, err := strconv.Atoi(nbrCarteStr)
	if err != nil {
		httpError(w, "Invalid number of cards specified", http.StatusBadRequest)
		return
	}

	ch := make(chan model.DBResponse)
	h.DBCh <- model.DBRequest{
		Action:     model.ActionDrawCards,
		DeckID:     deckID,
		Remaining:  nbrCarte,
		ResponseCh: ch,
	}
	res := <-ch
	if res.Error != nil {
		httpError(w, "Error drawing cards from the deck", http.StatusInternalServerError)
		return
	}

	cardsStrs := strings.Split(res.CardsStr, ",")
	cards := make([]map[string]interface{}, len(cardsStrs))
	for i, card := range cardsStrs {
		code := cardCodeFromSVGName(card)
		cards[i] = map[string]interface{}{
			"code":  code,
			"image": "/static/fronts/" + card + ".svg",
			"rank":  cardRankFromSVGName(card),
			"suit":  cardSuitFromSVGName(card),
		}
	}

	remaining := len(cardsStrs)
	jsonResponse(w, map[string]interface{}{
		"deck_id":   deckID,
		"cards":     cards,
		"remaining": remaining,
	})
}

func ServeCardImage(w http.ResponseWriter, r *http.Request) {
	svgName := path.Base(r.URL.Path)

	filePath := path.Join("../static/fronts/", svgName)

	if _, err := os.Stat(filePath); os.IsNotExist(err) {
		httpError(w, "File not found", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "image/svg+xml")

	http.ServeFile(w, r, filePath)

}

func httpError(w http.ResponseWriter, message string, status int) {
	log.Println(message)
	response, _ := json.Marshal(map[string]string{"error": message})
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	w.Write(response)
}
