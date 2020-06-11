#include "locators.h"
#include <math.h>
#include <QtCore/qmath.h>
#include <QDebug>
#include "../util/util.h"

// TODO: Remove
#include <QTime>

Locator::Locator(QObject *parent)
    : QObject(parent)
    , m_locations(QList<qreal>())
    , m_start(0)
    , m_end(1)
    , m_pixelSize(1)
    , m_multiples(QList<qreal>())
{
    // This default covers other magnitudes like 0.1, 0.5, 10, 20, 500, etc...
    m_multiples << 1 << 2 << 5;
    // Connect start, end, pixelSize with updateScale...
//    connect(this, &Locator::startChanged, this, &Locator::updateLocator);
//    connect(this, &Locator::endChanged, this, &Locator::updateLocator);
    connect(this, &Locator::pixelSizeChanged, this, &Locator::updateLocator);
}

/*! \internal
 * \property Locator::locations
 * The current locations of the locator.
 */
QList<qreal> Locator::locations() const
{
    return m_locations;
}

void Locator::setLocations(QList<qreal> arg)
{
    if (m_locations == arg) return;
    m_locations = arg;
    emit locationsChanged(arg);
}

/*! \internal
 * \property Locator::start
 * The minimum value of the locator. By default this is the attached axis' min
 * value.
 */
qreal Locator::start() const
{
    return m_start;
}

void Locator::setStart(qreal arg)
{
    if (m_start == arg) return;
    m_start = arg;
    emit startChanged(arg);
    updateLocator();
}

/*! \internal
 * \property Locator::end
 * The maximum value of the locator. By default this is the attached axis' max
 * value.
 */
qreal Locator::end() const
{
    return m_end;
}

void Locator::setEnd(qreal arg)
{
    if (m_end == arg) return;
    m_end = arg;
    emit endChanged(arg);
    updateLocator();
}

void Locator::setLimits(qreal start, qreal end)
{
    if (start == -Inf || end == Inf) return;
    bool updateStart = m_start != start;
    bool updateEnd = m_end != end;

    if (!updateStart && !updateEnd) return;

    m_start = start;
    m_end = end;

    if (updateStart)
        emit startChanged(start);
    if (updateEnd)
        emit endChanged(end);

    updateLocator();
}

/*! \internal
 * \property Locator::pixelSize
 * The number of pixels covered by this locator. By default this is the
 * attached axis' length.
 */
qreal Locator::pixelSize() const
{
    return m_pixelSize;
}

void Locator::setPixelSize(qreal arg)
{
    if (m_pixelSize == arg) return;
    m_pixelSize = arg;
    emit pixelSizeChanged(arg);
}

/*! \internal
 * \property Locator::multiples
 * The multiples by which the Locator increases.
 */
QList<qreal> Locator::multiples() const
{
    return m_multiples;
}

void Locator::setMultiples(QList<qreal> arg)
{
    if (m_multiples == arg) return;
    m_multiples = arg;
    emit multiplesChanged(arg);
}

QStringList Locator::locationLabels() const
{
    // Only return the labels if they're valid
    if (m_locationLabels.length() != m_locations.length())
        return QStringList();
    else
        return m_locationLabels;
}

void Locator::setLocationLabels(QStringList arg)
{
    if (m_locationLabels == arg) return;
    m_locationLabels = arg;
    emit locationLabelsChanged(arg);
}

void Locator::setLocationsAndLabels(QList<qreal> locs, QStringList labels) {
    bool newLocs = locs != m_locations;
    bool newLabels = labels != m_locationLabels;

    m_locations = locs;
    m_locationLabels = labels;

    if (newLocs) emit locationsChanged(locs);
    if (newLabels) emit locationLabelsChanged(labels);
}


//-------------------------------------------------------------------
//          AutoLocator
//-------------------------------------------------------------------

AutoLocator::AutoLocator(QObject *parent)
    : Locator(parent)
    , m_density(50)
{
}

AutoLocator::AutoLocator(qreal density, QObject *parent)
    : Locator(parent)
    , m_density(density)
{
    updateLocator();
}

/*!
 * \property AutoLocator::density
 * The preferred density of the locator in pixels/tick. Default: 50
 */
qreal AutoLocator::density() const
{
    return m_density;
}

void AutoLocator::setDensity(qreal arg)
{
    if (m_density == arg) return;
    m_density = arg;
    updateLocator();
    emit densityChanged(arg);
}

void AutoLocator::updateLocator()
{
    /* We want to find the multiple (n), and the magnitude (m) of the multiples that
     * get a tick density closest to the preferred density. The error can be
     * expressed in 2 ways:
     * density = scale*n*10^m + e   (1), OR
     * density = scale*n*10^(m+a)   (2)
     * Solving gives:
     * e = density*(1 - 10^(-a))
     * We want to minimise `e`
     */
    QTime timer; timer.start();
    // We can find `a` using (1)
    qreal scale = pixelSize()/(end() - start());
    if (scale <= 0) setLocations(QList<qreal>());

    qreal bestA = m_density, bestMult = 0;
    foreach (qreal n, multiples()) {
        qreal m_a = log10(m_density/(scale*n));
        qreal m = roundAt(m_a, 0.69897); // Approx. log10(5).
        qreal a = qAbs(m_a - m);
        if (a < bestA) {
            bestA = a;
            bestMult = n*qPow(10, m);
        }
    }

    if (bestMult == 0) return; // No good...

    // Round the start value up to the next valid value
    QList<qreal> newLocs;
    newLocs << ceil(start()/bestMult)*bestMult;
    while (newLocs.last() + bestMult <= end()) {
        qreal newVal = newLocs.last() + bestMult;
        // Precision errors in bestMult cause the locations to be off
        // by orders of ~1e-15. This causes issues when trying to desplay
        // zero. So we round to zero if the magnitude is less than 1/10
        // of a pixel.
        if (qAbs(newVal)*scale < 0.1)
            newVal = 0;
        newLocs << newVal;
    }

    // If less than 2 values remain, add the start and end values
    if (newLocs.length() < 2) {
        // Add a start or end tick if it isn't too close to the existing value
        qreal dStart = qAbs(newLocs[0] - start()), dEnd = qAbs(newLocs[0] - end());
        if (dStart > dEnd && dStart*scale > m_density/2)
            newLocs.prepend(start());
        else if (dEnd >= dStart && dEnd*scale > m_density/2)
            newLocs.append(end());
        else
            newLocs.clear();
    }

    if (newLocs.length() == 0)
        newLocs << start() << end();

    setLocations(newLocs);
}

qreal AutoLocator::roundAt(qreal n, qreal f)
{
    qreal nInt = qFloor(n);
    qreal nFrac = n - nInt < f ? 0 : 1;

    return nInt + nFrac;
}

// ------------------------------------------------------------------
//              HardLocator
// ------------------------------------------------------------------
HardLocator::HardLocator(QObject *parent)
    : Locator(parent)
    , m_hardLocations(QList<qreal>())
{
}

HardLocator::HardLocator(QList<qreal> hardLocs, QObject *parent)
    : Locator(parent)
    , m_hardLocations(hardLocs)
{
    updateLocator();
}

void HardLocator::setHardLocations(QList<qreal> arg)
{
    if (m_hardLocations == arg) return;
    m_hardLocations = arg;
    updateLocator();
    emit hardLocationsChanged(arg);
}

void HardLocator::updateLocator()
{
//    qDebug() << "Updating HardLocator" << start() << end() << m_hardLocations;
    QList<qreal> newLocs;
    foreach (qreal val, m_hardLocations) {
        if (val >= start() && val <= end())
            newLocs << val;
    }
    setLocations(newLocs);
}

/*!
 * \property HardLocator::hardLocations
 * The exact locations at which to show ticks. This is not dynamic at all.
 */
QList<qreal> HardLocator::hardLocations() const
{
    return m_hardLocations;
}

// ------------------------------------------------------------------
//          SpacedLocator
// ------------------------------------------------------------------
SpacedLocator::SpacedLocator(QObject *parent)
    : Locator(parent)
    , m_spacing(1)
{
}

SpacedLocator::SpacedLocator(qreal spc, QObject *parent)
    : Locator(parent)
    , m_spacing(spc)
{
    updateLocator();
}

void SpacedLocator::setSpacing(qreal arg)
{
    if (m_spacing == arg) return;
    m_spacing = arg;
    emit spacingChanged(arg);
}

void SpacedLocator::updateLocator()
{
    // Round the start value up to the next valid value
    QList<qreal> newLocs;
    newLocs << qCeil(start()/m_spacing)*m_spacing;
    while (newLocs.last() <= end())
        newLocs << newLocs.last() + m_spacing;
    // The last one is larger than the end value.
    newLocs.removeLast();
    setLocations(newLocs);
}

/*!
 * \property SpacedLocator::spacing
 * Manually specify the spacing for ticks. This is anchored to zero.
 */
qreal SpacedLocator::spacing() const
{
    return m_spacing;
}


LabelLocator::LabelLocator(QObject *parent)
    : HardLocator(parent)
    , m_labels(QStringList())
{

}

LabelLocator::LabelLocator(QStringList labels, QList<qreal> hardLocs, QObject *parent)
    : HardLocator(hardLocs, parent)
    , m_labels(labels)
{
    updateLocator();
}

QStringList LabelLocator::labels() const
{
    return m_labels;
}

void LabelLocator::setLabels(QStringList arg)
{
    if (m_labels == arg) return;
    m_labels = arg;
    updateLocator();
    emit labelsChanged(arg);
}

void LabelLocator::updateLocator()
{
    QList<qreal> newLocs;
    QStringList newLabels;

//    foreach (qreal val, hardLocations()) {
    for (int i = 0; i < hardLocations().length(); ++i) {
        qreal val = hardLocations()[i];
        if (val >= start() && val <= end()) {
            newLocs << val;
            newLabels << labels()[i];
        }
    }
    setLocationsAndLabels(newLocs, newLabels);
}
