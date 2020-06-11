#ifndef ROBO_MODEL_H
#define ROBO_MODEL_H

namespace domain
{
    class SightModel;
    class StatusModel;
    class TrackModel;
    class SettingsModel;
    class JoystickModel;

    class RoboModel
    {
    public:
        RoboModel();
        ~RoboModel();
        SightModel* sight() const;
        StatusModel* status() const;
        TrackModel* track() const;
        SettingsModel* settings() const;

    private:
        SightModel* m_sight = nullptr;
        StatusModel* m_status = nullptr;
        TrackModel* m_track = nullptr;
        SettingsModel* m_settings = nullptr;
    };
}

#endif //ROBO_MODEL_H
