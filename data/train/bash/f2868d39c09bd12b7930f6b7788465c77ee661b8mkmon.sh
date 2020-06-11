append () {
	sudo echo "$1" >> "$2"
}
sudo pacman -S mate-system-monitor
name="SystemMonitor.desktop"
cd "/home/$USER/Desktop"
sudo rm -f "$name"
sudo touch "$name"
sudo chmod a+rwx "$name"
append "[Desktop Entry]" "$name"
append "Version=1.0" "$name"
append "Type=Application" "$name"
append "Name=Mate System Monitor" "$name"
append "Comment=Mate System Monitor" "$name"
append "Exec=mate-system-monitor" "$name"
append "Terminal=false" "$name"
append "StartupNotify=false" "$name"
append "Icon=/usr/share/xscreensaver/glade/screensaver-diagnostic.png" "$name"
append "Path=" "$name"

echo "The Mate System Monitor Launcher was installed on your desktop."


