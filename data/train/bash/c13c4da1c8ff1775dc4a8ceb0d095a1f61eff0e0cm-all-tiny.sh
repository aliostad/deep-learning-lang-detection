#!/bin/sh
# cm bastion
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-bastion-prep-ubuntu.php
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-bastion-invoke-cleo-dapper-new.php
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-bastion-invoke-bastion.php
# cm git
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-git-prep-ubuntu.php
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-git-invoke-cleo-dapper-new.php
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-git-invoke-git.php
# cm build server
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-jenkins-prep-ubuntu.php
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-jenkins-invoke-cleo-dapper-new.php
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-jenkins-invoke-build-server.php
# cm staging
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-staging-prep-ubuntu.php
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-staging-invoke-cleo-dapper-new.php
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-staging-invoke-standalone-server.php
# cm prod
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-prod-prep-ubuntu.php
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-prod-invoke-cleo-dapper-new.php
cleopatra autopilot install build/config/cleopatra/autopilots/tiny-prod-invoke-standalone-server.php