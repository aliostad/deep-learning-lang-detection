using System.Collections.Generic;
using ApiChange.Api.Introspection;
using Mono.Cecil;

namespace ApiChange.Api.Extensions
{
  public class BetaApiBreakRuleStrategy : IApiBreakRuleStrategy
  {
    public ApiBreakLevel GetBreakLevel(AssemblyDiffCollection diffResult)
    {
      var defaultApiBreakRuleStrategy = new DefaultApiBreakRuleStrategy();

      var apiBreakLevel = defaultApiBreakRuleStrategy.GetBreakLevel(diffResult);

      if (apiBreakLevel == ApiBreakLevel.Major) return ApiBreakLevel.Minor;

      return apiBreakLevel;
    }
  }
}