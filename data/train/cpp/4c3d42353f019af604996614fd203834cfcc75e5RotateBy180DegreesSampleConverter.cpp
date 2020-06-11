#include "RotateBy180DegreesSampleConverter.hpp"

namespace VideoCapture {

RotateBy180DegreesSampleConverter::RotateBy180DegreesSampleConverter() {

}

RGBVideoFormat RotateBy180DegreesSampleConverter::convertedSampleFormat(
    RGBVideoFormat inputSampleFormat) const {
  if (!inputSampleFormat) {
    return inputSampleFormat;
  }
  boost::int32_t angleRotationDegrees(inputSampleFormat.angleRotationDegrees());
  angleRotationDegrees = (angleRotationDegrees + kAngleHalfRotationDegrees);
  angleRotationDegrees = (angleRotationDegrees % kAngleFullRotationDegrees);
  RGBVideoFormat outputSampleFormat(
      inputSampleFormat.uuid(),
      inputSampleFormat.sizePixels(),
      angleRotationDegrees,
      inputSampleFormat.rgbFormat());
  return outputSampleFormat;
}

void RotateBy180DegreesSampleConverter::convertSample(
      RGBVideoSampleRef inputSample,
      RGBVideoSampleRef outputSample) const {
  typedef RGBVideoFrame::ImageViewType ImageViewType;
  typedef RGBVideoSample::SampleDataSharedPtr SampleDataSharedPtr;
  if (!inputSample) {
    return;
  }
  if (!outputSample) {
    return;
  }
  SampleDataSharedPtr pInputSample(inputSample.sampleData());
  SampleDataSharedPtr pOutputSample(outputSample.sampleData());
  ImageViewType inputImageView(pInputSample->imageView());
  ImageViewType outputImageView(pOutputSample->imageView());
  boost::gil::copy_pixels(
      boost::gil::rotated180_view(inputImageView),
      outputImageView);
}

} // VideoCapture
