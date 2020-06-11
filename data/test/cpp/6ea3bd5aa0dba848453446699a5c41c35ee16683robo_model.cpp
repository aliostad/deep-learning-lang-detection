#include "robo_model.h"
#include "sight_model.h"
#include "track_model.h"
#include "settings_model.h"
#include "status_model.h"

using domain::RoboModel;
using domain::SightModel;
using domain::TrackModel;
using domain::SettingsModel;
using domain::StatusModel;

RoboModel::RoboModel()
{
    m_sight = new SightModel();
    m_track = new TrackModel();
    m_settings = new SettingsModel();
    m_status = new StatusModel();
}

RoboModel::~RoboModel()
{
    delete m_sight;
    delete m_status;
    delete m_track;
    delete m_settings;
}

SightModel *RoboModel::sight() const
{
    return m_sight;
}

StatusModel *RoboModel::status() const
{
    return m_status;
}

TrackModel *RoboModel::track() const
{
    return m_track;
}

SettingsModel *RoboModel::settings() const
{
    return m_settings;
}
