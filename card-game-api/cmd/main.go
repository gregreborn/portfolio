package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/gregreborn/Gregory-reseau/Devoir/card-game-api/api"
	"github.com/gregreborn/Gregory-reseau/Devoir/card-game-api/db"
	"github.com/gregreborn/Gregory-reseau/Devoir/card-game-api/model"
)

var dbCh chan model.DBRequest
var database *sql.DB

func databaseManager(dbCh chan model.DBRequest) {
	for request := range dbCh {
		switch request.Action {
		case model.ActionInitializeDeck:
			fmt.Println("Initializing DB...")
			err := db.InitializeDB(database)
			if err != nil {
				request.ResponseCh <- model.DBResponse{Error: err}
			}

		case model.ActionCreateDeck:
			fmt.Println("Creating Deck...")
			err := db.CreateDeck(database, request.DeckID, request.CardsStr)
			request.ResponseCh <- model.DBResponse{DeckID: request.DeckID, Error: err}

		case model.ActionShuffleDeck:
			fmt.Println("Shuffling Deck...")
			err := db.ShuffleDeck(database, request.DeckID)
			request.ResponseCh <- model.DBResponse{Error: err}
		case model.ActionGetDeck:
			fmt.Println("Fetching Deck...")
			cardsStr, _, err := db.GetDeck(database, request.DeckID) // Ignoring the returned remaining value
			if err != nil {
				fmt.Printf("Error fetching deck with ID %s: %v\n", request.DeckID, err)
			}
			remaining := len(strings.Split(cardsStr, ",")) // Compute remaining here
			request.ResponseCh <- model.DBResponse{DeckID: request.DeckID, CardsStr: cardsStr, Remaining: remaining, Error: err}

		case model.ActionAddCardsToDeck:
			fmt.Println("Adding Cards to Deck...")
			cards := strings.Split(request.CardsStr, ",")
			err := db.AddCards(database, request.DeckID, cards)
			request.ResponseCh <- model.DBResponse{Error: err}
		case model.ActionDrawCards:
			fmt.Println("Drawing Cards from Deck...")
			drawnCardsStr, err := db.DrawCards(database, request.DeckID, request.Remaining)
			if err != nil {
				request.ResponseCh <- model.DBResponse{Error: err}
				return
			}
			remaining := len(strings.Split(drawnCardsStr, ","))
			request.ResponseCh <- model.DBResponse{DeckID: request.DeckID, CardsStr: drawnCardsStr, Remaining: remaining, Error: err}

		default:
			fmt.Println("Unknown DB operation")
		}
	}
}

func main() {

	var err error
	database, err = sql.Open("sqlite3", "./cards.db")
	if err != nil {
		log.Fatalf("Error opening the SQLite database: %v", err)
	}
	defer database.Close()

	err = db.InitializeDB(database)
	if err != nil {
		log.Fatalf("Error initializing the SQLite database tables: %v", err)
	}
	dbCh = make(chan model.DBRequest)

	go databaseManager(dbCh)

	handler := &api.Handler{DBCh: dbCh}
	r := api.NewRouter(handler)

	http.Handle("/", r)
	log.Println("Server running on :8080")
	http.ListenAndServe(":8080", nil)
}
