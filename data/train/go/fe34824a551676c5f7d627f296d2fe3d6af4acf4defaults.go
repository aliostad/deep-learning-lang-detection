package settings

var EwmhSupported []string = []string{
	"_NET_SUPPORTED",
	"_NET_SUPPORTING_WM_CHECK",
	"_NET_DESKTOP_NAMES",
	"_NET_NUMBER_OF_DESKTOPS",
	"_NET_CURRENT_DESKTOP",
	"_NET_CLIENT_LIST",
	"_NET_ACTIVE_WINDOW",
	"_NET_CLOSE_WINDOW",
	"_NET_WM_DESKTOP",
	"_NET_WM_STATE",
	"_NET_WM_STATE_FULLSCREEN",
	"_NET_WM_STATE_STICKY",
	"_NET_WM_STATE_DEMANDS_ATTENTION",
	"_NET_WM_WINDOW_TYPE",
	"_NET_WM_WINDOW_TYPE_DOCK",
	"_NET_WM_WINDOW_TYPE_DESKTOP",
	"_NET_WM_WINDOW_TYPE_NOTIFICATION",
	"_NET_WM_WINDOW_TYPE_DIALOG",
	"_NET_WM_WINDOW_TYPE_UTILITY",
	"_NET_WM_WINDOW_TYPE_TOOLBAR",
}

func DefaultSettings() Settings {
	s := make(store)
	s.add("WindowManagerName", "scpwm")
	//s.add("ExternalRulesCommand", "")
	s.add("StatusPrefix", "W")
	s.add("SplitRatio", "0.5")
	s.add("WindowGap", "6")
	s.add("BorderWidth", "1")
	s.add("CenterPseudoTiled", "true")
	//s.add("RecordHistory", "true")
	s.add("DefaultMonitorName", "MONITOR")
	s.add("DefaultDesktopName", "DESKTOP")
	//s.add("InitialPolarity", "right")
	//s.add("Visible", "true")
	//s.add("StickyStill", "true")
	//s.add("AutoRaise", "true")

	n := &storeItem{key: "ewmhSupported"}
	n.List(EwmhSupported...)
	s.insert(n)

	s.insert(DefaultPad())

	return &settings{
		s: s,
	}
}
