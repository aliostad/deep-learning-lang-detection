# Training the face tracking models

PATCH_MODEL=models/patch
SHAPE_MODEL=models/shape
FACE_TRACKING_MODEL=models/face_tracking
ANNOTATIONS=data/annotations.yaml
FACEDET_MODEL=models/facedet
FACETRACK_MODEL=models/facetrack
CASCADE_MODEL="/usr/local//Cellar/opencv/2.4.10.1/share/OpenCV/lbpcascades/lbpcascade_frontalface.xml"

# ./src/trainshape $ANNOTATIONS $SHAPE_MODEL
# ./src/trainpatch $ANNOTATIONS $SHAPE_MODEL $PATCH_MODEL
# ./src/trainpatch $ANNOTATIONS $SHAPE_MODEL $PATCH_MODEL
# ./src/trainfacedet $CASCADE_MODEL $ANNOTATIONS $SHAPE_MODEL $FACEDET_MODEL 
# ./src/trainfacetrack $SHAPE_MODEL $PATCH_MODEL $FACEDET_MODEL $FACETRACK_MODEL
