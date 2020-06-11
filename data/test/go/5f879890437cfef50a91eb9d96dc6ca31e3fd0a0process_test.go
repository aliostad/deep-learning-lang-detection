package controller

import (
	"net/http"
	"net/http/httptest"
	"testing"
	"github.com/gorilla/mux"
	"github.com/golang/mock/gomock"
)

func setupProcessTest(t *testing.T, middleware HandlerFuncMiddleware) (*mux.Router, *MockProcessController) {
	ctl := gomock.NewController(t)
	defer ctl.Finish()

	router := mux.NewRouter()
	mockProcessController := NewMockProcessController(ctl)

	applyProcessRouter(router, mockProcessController, middleware)

	return router, mockProcessController
}

func Test_ProcessList(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationPassThroughMiddleware)
	processController.EXPECT().HandleListProcess(gomock.Any(), gomock.Any()).Times(1)

	req, _ := http.NewRequest("GET", "/process", nil)
	req.Header.Set("x-auth-token", "t-o-k-e-n")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_ProcessList_noToken(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationDropMiddleware)
	processController.EXPECT().HandleListProcess(gomock.Any(), gomock.Any()).Times(0)

	req, _ := http.NewRequest("GET", "/process", nil)
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_StartProcess(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationPassThroughMiddleware)
	processController.EXPECT().HandleStartProcess(gomock.Any(), gomock.Any()).Times(1)

	req, _ := http.NewRequest("POST", "/process", nil)
	req.Header.Set("x-auth-token", "t-o-k-e-n")
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_StartProcess_noToken(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationDropMiddleware)
	processController.EXPECT().HandleStartProcess(gomock.Any(), gomock.Any()).Times(0)

	req, _ := http.NewRequest("POST", "/process", nil)
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_StartProcess_wrongContentType(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationDropMiddleware)
	processController.EXPECT().HandleStartProcess(gomock.Any(), gomock.Any()).Times(0)

	req, _ := http.NewRequest("POST", "/process", nil)
	req.Header.Set("x-auth-token", "t-o-k-e-n")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_StartProcessAdmin(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationPassThroughMiddleware)
	processController.EXPECT().HandleStartProcessAdmin(gomock.Any(), gomock.Any()).Times(1)

	req, _ := http.NewRequest("POST", "/process/admin", nil)
	req.Header.Set("x-auth-token", "t-o-k-e-n")
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_StartProcessAdmin_noToken(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationDropMiddleware)
	processController.EXPECT().HandleStartProcess(gomock.Any(), gomock.Any()).Times(0)

	req, _ := http.NewRequest("POST", "/process/admin", nil)
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_StartProcessAdmin_wrongContentType(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationDropMiddleware)
	processController.EXPECT().HandleStartProcess(gomock.Any(), gomock.Any()).Times(0)

	req, _ := http.NewRequest("POST", "/process/admin", nil)
	req.Header.Set("x-auth-token", "t-o-k-e-n")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_ProcessSignal(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationPassThroughMiddleware)
	processController.EXPECT().HandleProcessSignal(gomock.Any(), gomock.Any()).Times(1)

	req, _ := http.NewRequest("POST", "/process/13/9", nil)
	req.Header.Set("x-auth-token", "t-o-k-e-n")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_ProcessSignal_noToken(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationDropMiddleware)
	processController.EXPECT().HandleProcessSignal(gomock.Any(), gomock.Any()).Times(0)

	req, _ := http.NewRequest("POST", "/process/13/9", nil)
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_ProcessInput(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationPassThroughMiddleware)
	processController.EXPECT().HandleProcessInput(gomock.Any(), gomock.Any()).Times(1)

	req, _ := http.NewRequest("POST", "/process/13", nil)
	req.Header.Set("x-auth-token", "t-o-k-e-n")
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_ProcessInput_noToken(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationDropMiddleware)
	processController.EXPECT().HandleProcessInput(gomock.Any(), gomock.Any()).Times(0)

	req, _ := http.NewRequest("POST", "/process/13", nil)
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_ProcessStatus(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationPassThroughMiddleware)
	processController.EXPECT().HandleProcessStatus(gomock.Any(), gomock.Any()).Times(1)

	req, _ := http.NewRequest("GET", "/process/13", nil)
	req.Header.Set("x-auth-token", "t-o-k-e-n")
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_ProcessStatus_noToken(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationDropMiddleware)
	processController.EXPECT().HandleProcessStatus(gomock.Any(), gomock.Any()).Times(0)

	req, _ := http.NewRequest("GET", "/process/13", nil)
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_ProcessOutput(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationPassThroughMiddleware)
	processController.EXPECT().HandleProcessOutput(gomock.Any(), gomock.Any()).Times(1)

	req, _ := http.NewRequest("GET", "/process/13/out", nil)
	req.Header.Set("x-auth-token", "t-o-k-e-n")
	req.Header.Set("Range", "0-")
	req.Header.Set("Accept", "application/octet-stream")
	router.ServeHTTP(httptest.NewRecorder(), req)
}

func Test_ProcessOutput_noToken(t *testing.T) {
	router, processController := setupProcessTest(t, AuthenticationDropMiddleware)
	processController.EXPECT().HandleProcessOutput(gomock.Any(), gomock.Any()).Times(0)

	req, _ := http.NewRequest("GET", "/process/13/out", nil)
	req.Header.Set("Range", "0-")
	req.Header.Set("Accept", "application/octet-stream")
	router.ServeHTTP(httptest.NewRecorder(), req)
}