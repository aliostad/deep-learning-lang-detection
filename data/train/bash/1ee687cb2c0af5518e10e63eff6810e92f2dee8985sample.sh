PACKAGES+=" sample"

V="0.0.1"
hset sample version $V
hset sample url "none"
hset sample prefix "/" 
hset sample depends "libsdl libsdlimage libsdlttf"

configure-sample() {
  echo Configuring sample
}

install-sample() {
  install echo Done
}

deploy-sample-local() {
  mkdir -p "$ROOTFS"/usr/share/scoreboard/images "$ROOTFS"/usr/share/scoreboard/logos "$ROOTFS"/usr/share/scoreboard/fonts
  cp -r images/* "$ROOTFS"/usr/share/scoreboard/images
  cp -r logos/* "$ROOTFS"/usr/share/scoreboard/logos
  cp -r fonts/* "$ROOTFS"/usr/share/scoreboard/fonts
  cp sample "$ROOTFS"/bin/
}

deploy-sample() {
  deploy deploy-sample-local
}
