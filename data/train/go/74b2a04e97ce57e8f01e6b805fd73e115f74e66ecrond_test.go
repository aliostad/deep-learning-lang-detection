package crond

import (
	"testing"

	. "github.com/smartystreets/goconvey/convey"
)

func TestNew(t *testing.T) {
	Convey("Testing New", t, func() {
		manager := New()
		So(manager, ShouldHaveSameTypeAs, Manager{})
	})
}

func TestManager_ParseCrontab(t *testing.T) {
	Convey("Testing Manager.ParseCrontab", t, func() {
		manager := New()

		err := manager.ParseCrontab(`
*   * * * *    echo minutely
*/2 * * * *    echo every 2 minutes
0   * * * *    echo hourly
0   0 * * *    echo daily at midnight
0   12 * * *   echo daily at noon
`)

		So(err, ShouldBeNil)
		So(len(manager.Rules()), ShouldEqual, 5)
		// So(manager.Rules()[0].Cmd(), ShouldEqual, "echo minutely")
	})
}
