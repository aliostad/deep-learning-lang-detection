package show

import (
	"net/http"

	"github.com/koffeinsource/notreddit/data"

	"github.com/gorilla/feeds"
	"github.com/gorilla/mux"

	"appengine"
)

//DispatchRSS returns the rss feed of namespace
func DispatchRSS(w http.ResponseWriter, r *http.Request) {
	c := appengine.NewContext(r)

	// get namespace
	namespace := mux.Vars(r)["namespace"]
	if namespace == "" {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	is, _, err := data.GetNewestItems(c, namespace, 20, "")
	if err != nil {
		c.Errorf("Error at in rss.dispatch @ GetNewestItem. Error: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	c.Infof("items: %v", is)

	feed := &feeds.Feed{
		Title: namespace + " - notRedd.it",
		Link:  &feeds.Link{Href: r.URL.String()},
	}

	for _, i := range is {
		rssI := feeds.Item{
			Title:       i.Caption,
			Link:        &feeds.Link{Href: i.URL},
			Description: i.Description,
			Created:     i.CreatedAt,
		}
		feed.Items = append(feed.Items, &rssI)
	}

	if s, err := feed.ToRss(); err == nil {
		w.Header().Set("Content-Type", "application/rss+xml")
		w.Write([]byte(s))
	} else {
		c.Errorf("Error at mashaling in www.dispatch. Error: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
}
