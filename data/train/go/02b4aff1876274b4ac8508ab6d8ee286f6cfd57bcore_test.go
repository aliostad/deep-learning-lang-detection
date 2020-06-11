// Copyright 2015 Jake Dahn
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package core

import (
	"io/ioutil"
	"testing"

	. "github.com/smartystreets/goconvey/convey"
)

func TestDispatchRequest(t *testing.T) {

	Convey("Given a valid Dispatch Request, the Fetcher should be able", t, func() {

		jsonRequest := `{
            "repo_url": "https://github.com/jakedahn/echo.git",
            "ref": "9284929047170968a2f5ab92968c3abac9242cc3",
            "arguments": [{"GOECHO": "wheeeeeeee"}]
        }`

		dispatchRequest, err := NewDispatchRequest([]byte(jsonRequest))
		So(err, ShouldBeNil)
		So(dispatchRequest.GitUrl, ShouldEqual, "https://github.com/jakedahn/echo.git")
		So(dispatchRequest.GitRef, ShouldEqual, "9284929047170968a2f5ab92968c3abac9242cc3")

		// fixme: I don't feel good about this data structure, feels weird
		for key, value := range dispatchRequest.Arguments[0] {
			So(key, ShouldEqual, "GOECHO")
			So(value, ShouldEqual, "wheeeeeeee")
		}

		Convey("to parse the contents of a Dispatchfile", func() {
			file, err := ioutil.ReadFile("../test/dispatch_test_file.yml")
			So(err, ShouldBeNil)

			df, err := ParseDispatchFile(file)
			So(err, ShouldBeNil)

			Convey("the build steps should be in order from top to bottom", func() {
				So(df.BuildSteps[0], ShouldEqual, "CGO_ENABLED=0 go build -o ./bin/echo -a main.go")
				So(df.BuildSteps[1], ShouldEqual, "docker build .")
				So(df.BuildSteps[2], ShouldEqual, "echo \"step3\"")
				So(df.BuildSteps[3], ShouldEqual, "echo \"step4\"")
				So(df.BuildSteps[4], ShouldEqual, "echo \"step5\"")
			})

			Convey("specifically the arguments", func() {
				So(df.Arguments[0].Key, ShouldEqual, "GOECHO")
				So(df.Arguments[0].Presence, ShouldEqual, "required")
			})
		})

		Convey("to determine if the Dispatch Request is valid", func() {
			file, err := ioutil.ReadFile("../test/dispatch_test_file.yml")
			So(err, ShouldBeNil)

			df, err := ParseDispatchFile(file)
			So(err, ShouldBeNil)
			So(df.Arguments[0].Key, ShouldEqual, "GOECHO")
			So(df.Arguments[0].Presence, ShouldEqual, "required")

			arguments := dispatchRequest.Arguments
			So(arguments[0]["GOECHO"], ShouldEqual, "wheeeeeeee")
			Convey("with good arguments", func() {
				So(dispatchRequest.IsValid(df), ShouldBeTrue)
			})
			Convey("with bad arguments", func() {
				delete(arguments[0], "GOECHO")
				So(arguments[0]["GOECHO"], ShouldEqual, "")
				So(dispatchRequest.IsValid(df), ShouldBeFalse)
			})
		})
	})

}

func TestDispatchFetcherIntegration(t *testing.T) {
	if testing.Short() {
		t.Skip("skipping test in short mode.")
	}

	Convey("Gifven a valid Dispatch Request, the Fetcher should be able", t, func() {

		jsonRequest := `{
            "repo_url": "https://github.com/jakedahn/echo.git",
            "ref": "9284929047170968a2f5ab92968c3abac9242cc3",
            "arguments": [{"GOECHO": "wheeeeeeee"}]
        }`

		dispatchRequest, err := NewDispatchRequest([]byte(jsonRequest))
		So(err, ShouldBeNil)

		Convey("to fetch the git repository", func() {
			repo := NewRepo(dispatchRequest.GitUrl, dispatchRequest.GitRef)
			So(repo.GitUrl, ShouldEqual, dispatchRequest.GitUrl)
			So(repo.GitRef, ShouldEqual, dispatchRequest.GitRef)
			So(repo.CheckoutPath, ShouldEqual, "")

			err := repo.Init()
			So(err, ShouldBeNil)
			So(repo.CheckoutPath, ShouldNotEqual, "")

			err = repo.Checkout()
			So(err, ShouldBeNil)
			head, err := repo.GitRepo.Head()
			So(err, ShouldBeNil)
			headCommit, err := repo.GitRepo.LookupCommit(head.Target())
			So(err, ShouldBeNil)
			So(headCommit.Id().String(), ShouldEqual, "9284929047170968a2f5ab92968c3abac9242cc3")
		})
	})
}
