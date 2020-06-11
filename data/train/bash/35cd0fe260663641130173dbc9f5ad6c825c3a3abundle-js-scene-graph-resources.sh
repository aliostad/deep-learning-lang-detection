#!/bin/sh

DATE=$(date '+%Y-%m-%d')

zip -qr js-scene-graph-resources-$DATE.zip \
  Apps/Sample/BasicDemos/Models \
  Apps/Sample/BasicDemos/Resources \
  Apps/Sample/BasicDemos/Resources/cubemap_opensea \
  Apps/Sample/Characters/Assets \
  Apps/Sample/Characters/Textures \
  Apps/Sample/Rendering/Models \
  Apps/Sample/Tutorials/Resources \
  Apps/Sample/Alembic/Models \
  Apps/Sample/Lidar/Models \
  Apps/Sample/UseCases/V8Engine/Models \
  Apps/Sample/UseCases/BulletPlayGround/Resources \
  Apps/Sample/UseCases/MedicalImaging/Resources \
  Apps/Sample/UseCases/CharacterAnimationTool/Resources\
  Apps/Sample/UseCases/CharacterAnimationTool/Textures\
  Apps/Sample/UseCases/PortScene/Models\
  Apps/Sample/UseCases/PortScene/Textures
