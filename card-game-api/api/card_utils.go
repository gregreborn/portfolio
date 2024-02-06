package api

import "strings"

func cardCodeFromSVGName(name string) string {
	if name == "joker_black" {
		return "JB"
	} else if name == "joker_red" {
		return "JR"
	}

	parts := strings.Split(name, "_")
	if len(parts) < 2 {
		return ""
	}
	rank := cardRankFromSVGName(name)
	suit := cardSuitFromSVGName(name)

	switch suit {
	case "clubs":
		suit = "C"
	case "diamonds":
		suit = "D"
	case "hearts":
		suit = "H"
	case "spades":
		suit = "S"
	}

	return rank + suit
}

func cardRankFromSVGName(name string) string {
	parts := strings.Split(name, "_")
	if len(parts) < 2 {
		return ""
	}

	rank := parts[1]

	switch rank {
	case "ace":
		return "A"
	case "jack":
		return "J"
	case "queen":
		return "Q"
	case "king":
		return "K"
	default:
		return rank
	}
}

func cardSuitFromSVGName(name string) string {
	parts := strings.Split(name, "_")
	if len(parts) == 0 {
		return ""
	}

	return parts[0]
}
