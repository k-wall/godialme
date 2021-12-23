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

	seen := make(map[string]int)
	for i := 1; i < 100; i++ {

		log.Println(net.LookupHost(host))

		c, err := net.Dial("tcp", fmt.Sprintf("%s:%s", host, port))
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Printf("Remote addr: %s\n", c.RemoteAddr().String())
		if val, ok := seen[c.RemoteAddr().String()]; ok {
			seen[c.RemoteAddr().String()] = val + 1
		} else {
			seen[c.RemoteAddr().String()] = 1
		}
		_ = c.Close()
	}

	fmt.Println("Remote address seen summary:")
	for key, val := range seen {
		fmt.Printf("%s => %d\n", key, val)
	}

}