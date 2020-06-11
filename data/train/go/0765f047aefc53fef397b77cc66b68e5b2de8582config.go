package config

import (
	"log"
	"os"

	"github.com/kelseyhightower/envconfig"

	"github.com/johnstcn/freshcomics/common/config"
)

type CrawlerConfig struct {
	config.Config
	CheckIntervalSecs 	int 	`default:"600"`
	CrawlDispatchSecs 	int 	`default:"10"`
	Backoff				[]int	`default:"1,10,30"`
	FetchTimeoutSecs	int		`default:"3"`
	UserAgent			string	`default:""`
}

var Cfg CrawlerConfig

func init() {
	err := envconfig.Process("freshcomics_crawler", &Cfg)
	if err != nil {
		log.Fatal(err.Error())
	}
	log.Println("[config] Debug:", os.Getenv("DEBUG") != "")
	log.Println("[config] Host:", Cfg.Host)
	log.Println("[config] Port:", Cfg.Port)
	log.Println("[config] CheckIntervalSecs:", Cfg.CheckIntervalSecs)
	log.Println("[config] CrawlDispatchSecs:", Cfg.CrawlDispatchSecs)
	log.Println("[config] Backoff:", Cfg.Backoff)
}
