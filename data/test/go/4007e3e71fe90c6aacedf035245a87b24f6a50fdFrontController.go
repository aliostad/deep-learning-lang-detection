package main

import (
	"fmt"
	"strings"
)

type View interface {
	show()
}

type HomeView struct {

}

func(h *HomeView)show(){
	fmt.Println("displaying home page");
}

type StudentView struct {

}

func(s *StudentView)show(){
	fmt.Println("displaying student page");
}


type Dispatcher struct {
	homeView *HomeView
	studentView *StudentView
}

func(d *Dispatcher)dispatch(request string) {
	if(strings.ToLower(request)=="student"){
		d.studentView.show()
	}else{
		d.homeView.show()
	}
}


type FrontController struct {
	dispatcher *Dispatcher
}

func(f *FrontController)isAuthenticUser() bool{
	fmt.Println("auther user sucessfully");
	return true;
}

func(f *FrontController)trackRequest(request string){
	fmt.Println("track Request:",request);
}

func(f *FrontController)dispatchRequest(request string){
	f.trackRequest(request)
	if(f.isAuthenticUser()){
		f.dispatcher.dispatch(request)
	}
}


func main(){
	frontController:=&FrontController{&Dispatcher{new(HomeView),new(StudentView)}}
	frontController.dispatchRequest("Home");
	frontController.dispatchRequest("student");
}