package main

import (
	"fmt"
	"log"
	"net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	//	if r.Method == "POST" {
	//		if err := r.ParseForm(); err != nil {
	//			fmt.Fprintf(w, "ParseForm() err: %v", err)
	//			return
	//		}
	//		name := r.FormValue("name")
	//		address := r.FormValue("address")
	//		w.Header().Set("Content-Type", "text/html")
	//		fmt.Fprintf(w, "Name = %s\n", name)
	//		fmt.Fprintf(w, "Address = %s\n", address)
	//		return
	//	}
	//
	//	http.ServeFile(w, r, "form.html")
	if r.Method == "GET" {
		id := r.URL.Query()["id"]
		w.Header().Set("Content-Type", "text/html")
		fmt.Fprintf(w, "id = %s\n", id)
		return
	}

	http.ServeFile(w, r, "form.html")

}

func main() {
	http.HandleFunc("/", helloHandler)

	fmt.Printf("Starting server at port 8080\n")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
