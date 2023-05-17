package main

import (
	"log"
	"flag"

	"github.com/frolovo22/tag"
)

var fArtist = flag.String("artist", "Le Artiste!", "Sets the artist tag")
var fAlbum = flag.String("album", "L'oeuvre", "Sets the album")
var fGenre = flag.String("genre", "La Genre", "Sets the genre")
var fTitle = flag.String("title", "Ceci n'est pas une titre", "Sets the title")
var fPic = flag.String("pic", "A picture", "Sets the cover art")

/*

./tageditor

*/



func main() {
	flag.Parse()

	for _, fi := range flag.Args() {
		log.Println(fi)

		tag, err := tag.ReadFile(fi)
		if err != nil {
			log.Fatalf("can't open %q: %v", fi, err)
		}

		title, err := tag.GetTitle()
		if err != nil {
			log.Println("can't get title", err)
			continue
		}
		log.Printf("got a title %q", title)

// Observe: I can't delete them. I can't add them.

//		tag.SetArtist(*fArtist)
//		tag.SetAlbum(*fAlbum)
//		tag.SetAlbum(*fGenre)
//		tag.SetTitle(*fTitle)
		
		// Picture

//		if err := tag.SaveFile(fi); err != nil {
//			log.Fatalf("can't write the modified metadata to %q: %v", fi, err)
//		}
	}
}

