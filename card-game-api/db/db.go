package db

import (
	"database/sql"
	"math/rand"
	"strings"
	"time"

	"github.com/google/uuid"
	_ "github.com/ncruces/go-sqlite3/driver"
	_ "github.com/ncruces/go-sqlite3/embed"
)

func normalizeSQL(query string) string {
	return strings.Join(strings.Fields(query), " ")
}

func InitializeDB(db *sql.DB) error {
	createTableQuery := normalizeSQL(`
    CREATE TABLE IF NOT EXISTS decks (
        id INTEGER PRIMARY KEY,
		deck_id TEXT NOT NULL,
        card TEXT,
		position INTEGER
    );`)

	_, err := db.Exec(createTableQuery)
	if err != nil {
		return err
	}

	return nil
}

func CreateDeck(db *sql.DB, deckID string, cardsStr string) error {
	cards := strings.Split(cardsStr, ",")
	tx, err := db.Begin()
	if err != nil {
		return err
	}

	for i, card := range cards {
		_, err = tx.Exec("INSERT INTO decks (deck_id, card, position) VALUES (?, ?, ?)", deckID, card, i)
		if err != nil {
			tx.Rollback()
			return err
		}
	}

	return tx.Commit()
}

func GetDeck(db *sql.DB, deckID string) (string, int, error) {
	rows, err := db.Query("SELECT card FROM decks WHERE deck_id = ? ORDER BY position ASC", deckID)
	if err != nil {
		return "", 0, err
	}
	defer rows.Close()

	var cards []string
	for rows.Next() {
		var card string
		if err := rows.Scan(&card); err != nil {
			return "", 0, err
		}
		cards = append(cards, card)
	}

	if err := rows.Err(); err != nil {
		return "", 0, err
	}

	return strings.Join(cards, ","), len(cards), nil
}

func ShuffleDeck(db *sql.DB, deckID string) error {
	cardsStr, _, err := GetDeck(db, deckID)
	if err != nil {
		return err
	}

	cards := strings.Split(cardsStr, ",")

	rand.New(rand.NewSource(time.Now().UnixNano()))
	rand.Shuffle(len(cards), func(i, j int) {
		cards[i], cards[j] = cards[j], cards[i]
	})

	tx, err := db.Begin()
	if err != nil {
		return err
	}

	for i, card := range cards {
		_, err := tx.Exec("UPDATE decks SET position = ? WHERE deck_id = ? AND card = ?", i, deckID, card)
		if err != nil {
			tx.Rollback()
			return err
		}
	}

	return tx.Commit()
}

func InitializeDeck(db *sql.DB, nbrPaquet int) (string, error) {
	allCards := []string{
		"AS", "2S", "3S", "4S", "5S", "6S", "7S", "8S", "9S", "10S", "JS", "QS", "KS", "AH", "2H", "3H", "4H", "5H", "6H", "7H", "8H", "9H", "10H", "JH", "QH", "KH", "AD", "2D", "3D", "4D", "5D", "6D", "7D", "8D", "9D", "10D", "JD", "QD", "KD", "AC", "2C", "3C", "4C", "5C", "6C", "7C", "8C", "9C", "10C", "JC", "QC", "KC",
	}

	deckID := generateRandomDeckID()

	for i, card := range allCards {
		for j := 0; j < nbrPaquet; j++ {
			position := (i + 1) + (j * len(allCards))
			_, err := db.Exec("INSERT INTO decks (deck_id, card, position) VALUES (?, ?, ?)", deckID, card, position)
			if err != nil {
				return "", err
			}
		}
	}

	return deckID, nil
}

func generateRandomDeckID() string {
	return uuid.New().String()
}

func DrawCards(db *sql.DB, deckID string, nbrCarte int) (string, error) {
	rows, err := db.Query("SELECT card FROM decks WHERE deck_id = ? ORDER BY position ASC LIMIT ?", deckID, nbrCarte)
	if err != nil {
		return "", err
	}
	defer rows.Close()

	var drawnCards []string
	for rows.Next() {
		var card string
		if err := rows.Scan(&card); err != nil {
			return "", err
		}
		drawnCards = append(drawnCards, card)
	}

	placeholders := make([]string, len(drawnCards))
	for i := range drawnCards {
		placeholders[i] = "?"
	}
	query := "DELETE FROM decks WHERE deck_id = ? AND card IN (" + strings.Join(placeholders, ",") + ")"
	args := make([]interface{}, len(drawnCards)+1)
	args[0] = deckID
	for i, card := range drawnCards {
		args[i+1] = card
	}
	_, err = db.Exec(query, args...)
	if err != nil {
		return "", err
	}

	return strings.Join(drawnCards, ","), nil
}

func AddCards(db *sql.DB, deckID string, cardsToAdd []string) error {
	var minPosition int
	row := db.QueryRow("SELECT MIN(position) FROM decks WHERE deck_id = ?", deckID)
	err := row.Scan(&minPosition)
	if err != nil {
		return err
	}

	startPosition := minPosition - 1
	for _, card := range cardsToAdd {
		_, err := db.Exec("INSERT INTO decks (deck_id, card, position) VALUES (?, ?, ?)", deckID, card, startPosition)
		if err != nil {
			return err
		}
		startPosition--
	}

	return nil
}
