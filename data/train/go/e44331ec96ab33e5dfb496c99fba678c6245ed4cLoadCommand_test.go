package cmd

import (
	check "gopkg.in/check.v1"
)

type LoadCommandSuite struct {
	target *testTarget
}

var _ = check.Suite(&LoadCommandSuite{})

func (suite *LoadCommandSuite) SetUpTest(c *check.C) {
	suite.target = &testTarget{}
}

func (suite *LoadCommandSuite) TestLoadCommandReturnsNilForUnknownText(c *check.C) {
	result := loadCommand("not load")

	c.Assert(result, check.IsNil)
}

func (suite *LoadCommandSuite) TestLoadCommandReturnsLoadFunctionForProperParameter(c *check.C) {
	result := loadCommand("load \"path1\" \"path2\"")

	result(suite.target)

	c.Assert(len(suite.target.loadParam), check.Equals, 1)
}

func (suite *LoadCommandSuite) TestLoadCommandHandlesVariousParameterFormats(c *check.C) {
	suite.verifyLoadParameter(c, `load "path1" "path2"`, "path1", "path2")
	suite.verifyLoadParameter(c, `load   "path1"   "path2"`, "path1", "path2")
	suite.verifyLoadParameter(c, `load   "path1""path2"`, "path1", "path2")
	suite.verifyLoadParameter(c, `load "justOnePath"`, "justOnePath", "")
	suite.verifyLoadParameter(c, `load "path with blanks"`, "path with blanks", "")
}

func (suite *LoadCommandSuite) verifyLoadParameter(c *check.C, input, path1, path2 string) {
	result := loadCommand(input)

	c.Assert(result, check.Not(check.IsNil))
	result(suite.target)

	c.Check(suite.target.loadParam[len(suite.target.loadParam)-1], check.DeepEquals, []interface{}{path1, path2})
}
