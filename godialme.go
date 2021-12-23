package main

import (
	"fmt"
	"log"
	"net"
	"os"
)


func main() {
	arguments := os.Args

	if len(arguments) != 3 {
		fmt.Printf("Please provide host port. Expecting 2 args got %s\n", len(arguments))
		return
	}

	host := arguments[1]
	port := arguments[2]

	for {

		log.Println(net.LookupHost(host))

		c, err := net.Dial("tcp", fmt.Sprintf("%s:%s", host, port))
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Printf("Remote addr: %s\n", c.RemoteAddr())
		_ = c.Close()
	}


}