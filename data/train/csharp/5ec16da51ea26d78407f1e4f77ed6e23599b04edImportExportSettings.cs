using System;
using Tauron.JetBrains.Annotations;

namespace Tauron.Application.RadioStreamer.Contracts.Data
{
    [Serializable]
    public sealed class ImportExportSettings
    {
        public bool ProcessRadios { get; private set; }

        public bool ProcessSettings { get; private set; }

        public bool ProcessPlugIns { get; private set; }

        public bool ProcessScripts { get; private set; }

        public ImportExportSettings(bool processRadios, bool processSettings, bool processPlugIns, bool processScripts)
        {
            ProcessRadios = processRadios;
            ProcessSettings = processSettings;
            ProcessPlugIns = processPlugIns;
            ProcessScripts = processScripts;
        }

        [NotNull]
        public ImportExportSettings Merge([NotNull] ImportExportSettings settings)
        {
            ProcessPlugIns = ProcessPlugIns && settings.ProcessPlugIns;
            ProcessRadios = ProcessRadios && settings.ProcessRadios;
            ProcessScripts = ProcessScripts && settings.ProcessScripts;
            ProcessSettings = ProcessSettings && settings.ProcessSettings;

            return this;
        }
    }
}