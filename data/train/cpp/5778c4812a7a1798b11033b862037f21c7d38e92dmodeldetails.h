#ifndef DMODELDETAILS_H
#define DMODELDETAILS_H

/**
 * @defgroup modeldetails Model Details
 * @Encodes model-specific information.
 * @{
 */

int modelMiddlePosition(int model);
int modelMaxPosition(int model);
int modelMinPosition(int model);
int modelMaxSpeed(int model, int mode);
int modelMinSpeed(int model, int mode);
int modelAngleRange(int model);
int modelMaxRPM(int model);
int modelDefaultBaudRate(int model);

bool pidCapable(int model);
bool complianceSettingCapable(int model);
bool bulkreadCapable(int model);

/** @} */

#endif // DMODELDETAILS_H
