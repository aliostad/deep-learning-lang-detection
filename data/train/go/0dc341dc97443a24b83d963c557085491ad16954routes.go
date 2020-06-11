//
//  2016 October 17
//  John Gilliland [john.gilliland@rndgroup.com]
//

/*
    Package service contains the instrument provider api implementation.
*/
package service


import (
    "net/http"
    
    "github.com/gin-gonic/gin"
    "v.io/x/lib/vlog"
)

type postFunc func(c *gin.Context) (interface{}, *ApiError)

func logger() gin.HandlerFunc {
	return func(c *gin.Context) {
		vlog.Info("HTTP ", c.ClientIP(), " ", c.Request.Method, " ", c.Request.URL.Path)
	}
}

func wrapPost(postImpl postFunc) gin.HandlerFunc {
	return func(c *gin.Context) {
		result, appErr := postImpl(c)
		if appErr != nil {
			c.JSON(appErr.HTTPErrorCode, gin.H{"error": appErr.Message})
		} else {
			c.JSON(http.StatusOK, gin.H{"result": result})
		}
	}
}

// Register method creates the routes used for the instrument api
func Register() *gin.Engine {
    gin.SetMode(gin.DebugMode)

    router := gin.Default()
    router.Use(logger())

    group := router.Group("instrument/v1")
    group.GET("/load-method", wrapPost(LoadMethod))

    return router
}