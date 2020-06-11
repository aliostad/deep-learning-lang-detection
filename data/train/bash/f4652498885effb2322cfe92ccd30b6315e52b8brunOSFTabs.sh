osascript -e 'tell application "Terminal"
  activate
  do script "workon osf && cd ~/osf.io && invoke mongo -d"
  my makeTab()
  do script "workon osf && cd ~/osf.io && invoke mailserver" in tab 2 of front window
  my makeTab()
  do script "workon osf && cd ~/osf.io && invoke rabbitmq" in tab 3 of front window
  my makeTab()
  do script "workon osf && cd ~/osf.io && invoke celery_worker" in tab 4 of front window
  my makeTab()
  do script "workon osf && cd ~/osf.io && invoke elasticsearch" in tab 5 of front window
  my makeTab()
  do script "workon osf && cd ~/osf.io && invoke assets -dw" in tab 6 of front window
  my makeTab()
  do script "workon osf && cd ~/osf.io && invoke server" in tab 7 of front window
  my makeTab()
  do script "workon osf && ./fakecas" in tab 8 of front window
end tell

on makeTab()
  tell application "System Events" to keystroke "t" using {command down}
  delay 0.2
end makeTab'