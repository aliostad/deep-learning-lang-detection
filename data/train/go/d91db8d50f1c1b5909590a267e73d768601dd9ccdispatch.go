package dispatch

import (
	"net/http"

	"github.com/labstack/echo"
	"github.com/taitan-org/gomqtt/gateway/gate"
	"github.com/uber-go/zap"
)

/* Dispatch a room ip to the client which is requesting */
type Dispatch struct {
}

type Resp struct {
	Result string `json:"result"`
	Data   string `json:"data"`
}

func New() *Dispatch {
	return &Dispatch{}
}

func (d *Dispatch) Start() {
	e := echo.New()

	// configuration hot update
	e.Any("/dispatch", dispatch)

	err := e.Start(gate.Conf.Dispatch.Addr)
	if err != nil {
		e.Logger.Fatal(err.Error())
	}
}

func dispatch(c echo.Context) error {
	var acc string

	switch c.Request().Method {
	case "GET":
		acc = c.QueryParam("account")

	case "POST":
		acc = c.FormValue("account")

	default:
		gate.Logger.Info("invalid request method", zap.String("method", c.Request().Method))
	}

	if acc == "" {
		c.JSON(http.StatusOK, Resp{
			Result: "error",
			Data:   "invalid params",
		})
	} else {
		ip, err := gate.Consist.Get(acc)
		if err != nil {
			gate.Logger.Info("get consist ip error", zap.Error(err), zap.Object("consist", gate.Consist.Members()))
			c.JSON(http.StatusOK, Resp{
				Result: "error",
				Data:   "no room available",
			})
		}

		c.JSON(http.StatusOK, Resp{
			Result: "success",
			Data:   ip,
		})
	}

	return nil
}
