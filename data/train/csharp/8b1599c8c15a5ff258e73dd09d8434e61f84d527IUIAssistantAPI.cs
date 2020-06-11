using System.Windows.Controls;
using UIAssistant.Interfaces.Plugin;
using UIAssistant.Interfaces.Settings;

namespace UIAssistant.Interfaces.API
{
    public interface IUIAssistantAPI
    {
        string ConfigurationDirectory { get; }
        IFileIO DefaultSettingsFileIO { get; }
        IUserSettings UIAssistantSettings { get; }

        void Initialize(Control defaultHUDPanel, Control defaultContextPanel);
        IPluginManager PluginManager { get; }

        IScreen Screen { get; }

        IAutomationAPI AutomationAPI { get; }
        ICommandAPI CommandAPI { get; }
        IHitaHintAPI HitaHintAPI { get; }
        IKeyboardAPI KeyboardAPI { get; }
        ILocalizationAPI LocalizationAPI { get; }
        ILogAPI LogAPI { get; }
        IMouseAPI MouseAPI { get; }
        INotificationAPI NotificationAPI { get; }
        ISessionAPI SessionAPI { get; }
        IThemeAPI ThemeAPI { get; }
        IViewAPI ViewAPI { get; }
        IWindowAPI WindowAPI { get; }
    }
}
