package main

import (
  "os"
    "github.com/codegangsta/cli"
    )

func main() {
  app := cli.NewApp()
    app.Name = "morse"
      app.Usage = "fight the loneliness!"
        app.Action = func(c *cli.Context) {
	    //println("Hello friend!")
	    //println()
	    //println(c.Args()[0][0])
	    for i:=0; i<len(c.Args()[0]); i++ {
	    j:=c.Args()[0][i]
	    //println(j)
	    switch j{
	    case 65,97:print(".- ")
	    case 66,98:print("-... ")
	    case 67,99:print("-.-. ")
	    case 68,100:print("-.. ")
	    case 69,101:print(". ")
	    case 70,102:print("..-. ")
	    case 71,103:print("--. ")
	    case 72,104:print(".... ")
	    case 73,105:print(".. ")
	    case 74,106:print(".--- ")
	    case 75,107:print("-.- ")
	    case 76,108:print(".-.. ")
	    case 77,109:print("-- ")
	    case 78,110:print("-. ")
	    case 79,111:print("--- ")
	    case 80,112:print(".--. ")
	    case 81,113:print("--.- ")
	    case 82,114:print(".-. ")
	    case 83,115:print("... ")
	    case 84,116:print("- ")
	    case 85,117:print("..- ")
	    case 86,118:print("...- ")
	    case 87,119:print(".-- ")
	    case 88,120:print("-..- ")
	    case 89,121:print("-.-- ")
	    case 90,122:print("--.. ")
}
}
	      }

  app.Run(os.Args)
}
