package model

type DBAction int

const (
	ActionCreateDeck DBAction = iota
	ActionGetDeck
	ActionUpdateDeck
	ActionShuffleDeck
	ActionAddCardsToDeck DBAction = iota
	ActionInitializeDeck DBAction = iota
	ActionDrawCards      DBAction = iota
)

type DBRequest struct {
	Action     DBAction
	DeckID     string
	CardsStr   string
	Remaining  int
	ResponseCh chan DBResponse
}

type DBResponse struct {
	DeckID    string
	CardsStr  string
	Remaining int
	Error     error
}
