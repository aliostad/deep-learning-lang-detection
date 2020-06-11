#ifndef SAMPLEOPTIONS_HPP
#define SAMPLEOPTIONS_HPP

#include <QObject>

#include "gl/OpenGLPointers.hpp"
#include "model/OpenGLState.hpp"

namespace balls {

class SampleOptions : public OpenGLState {
  Q_OBJECT

  // clang-format off
  Q_PROPERTY(float sampleCoverage MEMBER m_sampleCoverage WRITE setSampleCoverage FINAL)
  Q_PROPERTY(bool invertSampleCoverage MEMBER m_invertSampleCoverage WRITE setInvertSampleCoverage FINAL)
  Q_PROPERTY(bool sampleAlphaToCoverage MEMBER m_sampleAlphaToCoverage WRITE setSampleAlphaToCoverage FINAL)
  Q_PROPERTY(bool sampleAlphaToOne MEMBER m_sampleAlphaToOne WRITE setSampleAlphaToOne FINAL)
  Q_PROPERTY(bool sampleCoverageEnabled MEMBER m_sampleCoverageEnabled WRITE setSampleCoverageEnabled FINAL)
  Q_PROPERTY(bool sampleShadingEnabled MEMBER m_sampleShadingEnabled WRITE setSampleShadingEnabled FINAL)
  Q_PROPERTY(bool sampleMaskEnabled MEMBER m_sampleMaskEnabled WRITE setSampleMaskEnabled FINAL)
  Q_PROPERTY(bool multisample MEMBER m_multisample WRITE setMultisample FINAL)
  Q_PROPERTY(float minSampleShading MEMBER m_minSampleShading WRITE setMinSampleShading FINAL)
  // clang-format on

public:
  explicit SampleOptions(OpenGLPointers&, QObject* = nullptr);

private /* setters */:
  void setSampleCoverage(float) noexcept;
  void setInvertSampleCoverage(bool) noexcept;
  void setSampleAlphaToCoverage(bool) noexcept;
  void setSampleAlphaToOne(bool) noexcept;
  void setSampleCoverageEnabled(bool) noexcept;
  void setSampleShadingEnabled(bool) noexcept;
  void setSampleMaskEnabled(bool) noexcept;
  void setMultisample(bool) noexcept;
  void setMinSampleShading(float) noexcept;

private /* fields */:
  float m_sampleCoverage;
  bool m_invertSampleCoverage;
  bool m_sampleAlphaToCoverage;
  bool m_sampleAlphaToOne;
  bool m_sampleCoverageEnabled;
  bool m_sampleShadingEnabled;
  bool m_sampleMaskEnabled;
  bool m_multisample;
  float m_minSampleShading;
};
}

Q_DECLARE_METATYPE(balls::SampleOptions*)

#endif // SAMPLEOPTIONS_HPP
