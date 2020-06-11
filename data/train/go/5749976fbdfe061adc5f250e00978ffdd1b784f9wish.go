/*
* @Author: souravray
* @Date:   2014-10-20 16:37:23
* @Last Modified by:   souravray
* @Last Modified time: 2014-10-21 12:44:36
 */

package controllers

import (
	"encoding/json"
	"github.com/souravray/gadgetWish/models"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"net/http"
	"time"
)

func WishList(w http.ResponseWriter, r *http.Request) {
	var wishes models.Wishes
	wishes = []models.Wish{}
	session, _ := store.Get(r, "wishlist-session")
	if session.Values["user"] != nil {
		user := session.Values["user"].(*models.User)
		s, err := mgo.Dial(conf.DbURI)
		defer s.Close()
		if err != nil {
			dispatchError(w, "database not responding")
			return
		}

		s.SetMode(mgo.Monotonic, true)
		c := s.DB(conf.DbName).C("wishes")
		err = c.Find(bson.M{"user_email": user.Email}).All(&wishes)

		if err != nil {
			dispatchError(w, "error")
			return
		}
	}
	dispatchJSON(w, wishes)
}

func AddWish(w http.ResponseWriter, r *http.Request) {
	var wish models.Wish
	session, _ := store.Get(r, "wishlist-session")
	if session.Values["user"] != nil {
		user := session.Values["user"].(*models.User)
		s, err := mgo.Dial(conf.DbURI)
		defer s.Close()
		if err != nil {
			dispatchError(w, "database not responding")
			return
		}

		s.SetMode(mgo.Monotonic, true)
		c := s.DB(conf.DbName).C("wishes")

		decoder := json.NewDecoder(r.Body)
		err = decoder.Decode(&wish)
		if err != nil {
			dispatchError(w, "parse error")
			return
		}
		wish.UserEmail = user.Email
		wish.Timestamp = time.Now()

		err = user.Validator()
		if err != nil {
			dispatchError(w, err.Error())
			return
		}

		selector := bson.M{"$and": []bson.M{
			bson.M{"user_email": wish.UserEmail},
			bson.M{"product_id": wish.Product}}}
		err = c.Find(selector).One(&wish)

		if err == nil {
			dispatchError(w, "this product is already in users wishlist")
			return
		}
		err = c.Insert(wish)
		if err != nil {
			dispatchError(w, "cannot add to user wishlist")
			return
		}
	}
	dispatchJSON(w, wish)
}

func RemoveWish(w http.ResponseWriter, r *http.Request) {
	var wish models.Wish
	session, _ := store.Get(r, "wishlist-session")
	if session.Values["user"] != nil {
		user := session.Values["user"].(*models.User)
		s, err := mgo.Dial(conf.DbURI)
		defer s.Close()
		if err != nil {
			dispatchError(w, "database not responding")
			return
		}

		s.SetMode(mgo.Monotonic, true)
		c := s.DB(conf.DbName).C("wishes")

		id := r.FormValue("product_id")
		wish.Product = bson.ObjectIdHex(id)

		selector := bson.M{"$and": []bson.M{
			bson.M{"user_email": user.Email},
			bson.M{"product_id": wish.Product}}}

		err = c.Remove(selector)

		if err != nil {
			dispatchError(w, "cannot remove from user wishlist")
			return
		}
	}
	dispatchJSON(w, wish)
}
