using Pepino.ScenarioRunner.ApiSteps;
using Pepino.ScenarioRunner.Application;

namespace Pepino.ScenarioRunner.TestingCommon
{
    public class FakeApiAssertExecutionStrategy : IApiAssertExecutionStrategy<FakeApiAssert>
    {
        ApiAssertResult _apiAssertResult;

        public ApiAssertResult Execute(FakeApiAssert apiStep, ScenarioContext context)
        {
            return _apiAssertResult;
        }

        public FakeApiAssertExecutionStrategy Returns(ApiAssertResult apiAssertResult)
        {
            _apiAssertResult = apiAssertResult;
            return this;
        }
    }
}