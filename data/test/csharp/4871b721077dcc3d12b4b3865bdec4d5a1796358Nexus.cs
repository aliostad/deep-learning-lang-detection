// Decompiled with JetBrains decompiler
// Type: Sitecore.Reflection.Nexus
// Assembly: Sitecore.Kernel, Version=10.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 1FC83769-B7FD-4542-AD6B-822F5E5605FC
// Assembly location: E:\MyProject\Sitecore\Lib\Sitecore.Kernel.dll

using Sitecore.Diagnostics;

namespace Sitecore.Reflection
{
  public static class Nexus
  {
    private static readonly object _lock = new object();
    private static INexusDataApi _dataApi;
    private static INexusLicenseApi _licenseApi;
    private static INexusPlaceholderApi _placeholderApi;
    private static INexusPipelineApi _pipelineApi;

    public static INexusDataApi DataApi
    {
      get
      {
        return Nexus.GetApi<INexusDataApi>("Sitecore.Nexus.Data.NexusDataApi, Sitecore.Nexus", ref Nexus._dataApi);
      }
    }

    public static INexusLicenseApi LicenseApi
    {
      get
      {
        return Nexus.GetApi<INexusLicenseApi>("Sitecore.Nexus.Licensing.NexusLicenseApi, Sitecore.Nexus", ref Nexus._licenseApi);
      }
    }

    public static INexusPlaceholderApi PlaceholderApi
    {
      get
      {
        return Nexus.GetApi<INexusPlaceholderApi>("Sitecore.Nexus.Web.NexusPlaceholderApi, Sitecore.Nexus", ref Nexus._placeholderApi);
      }
    }

    public static INexusPipelineApi PipelineApi
    {
      get
      {
        return Nexus.GetApi<INexusPipelineApi>("Sitecore.Nexus.Pipelines.NexusPipelineApi, Sitecore.Nexus", ref Nexus._pipelineApi);
      }
    }

    private static T GetApi<T>(string typeName, ref T api) where T : class
    {
      if ((object) api != null)
        return api;
      lock (Nexus._lock)
      {
        if ((object) api != null)
          return api;
        api = ReflectionUtil.CreateObject(typeName, new object[0]) as T;
        Assert.IsNotNull((object) api, "Could not instantiate the type '{0}'", (object) typeName);
        return api;
      }
    }
  }
}
