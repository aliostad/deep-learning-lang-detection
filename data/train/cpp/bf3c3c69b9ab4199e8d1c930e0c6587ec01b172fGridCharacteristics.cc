#include "GridCharacteristics.hh"

GridCharacteristics::GridCharacteristics() {
}

GridCharacteristics::~GridCharacteristics(){
}

double GridCharacteristics::getTimeZone() {
    return timeZone;
}

double GridCharacteristics::getPeakLoadWeekday() {
    return peakLoadWeekday;
}

double GridCharacteristics::getOffLoadWeekday() {
    return offLoadWeekday;
}

double GridCharacteristics::getPeakLoadHoliday() {
    return peakLoadHoliday;
}

double GridCharacteristics::getOffLoadHoliday() {
    return offLoadHoliday;
}

Distribution* GridCharacteristics::getLoadAdjusting() {
    return loadAdjusting;
}

vector<double>& GridCharacteristics::getWeekdayLoad() {
    return weekdayLoad;
}

vector<double>& GridCharacteristics::getHolidayLoad() {
    return holidayLoad;
}

void GridCharacteristics::setTimeZone (double timeZone) {
    this->timeZone = timeZone;
}

void GridCharacteristics::setPeakLoadWeekday (double peakLoadWeekday) {
    this->peakLoadWeekday = peakLoadWeekday;
}

void GridCharacteristics::setOffLoadWeekday (double offLoadWeekday){
    this->offLoadWeekday = offLoadWeekday;
}

void GridCharacteristics::setPeakLoadHoliday (double peakLoadHoliday) {
    this->peakLoadHoliday = peakLoadHoliday;
}

void GridCharacteristics::setLoadAdjusting  (Distribution* loadAdjusting) {
    this->loadAdjusting = loadAdjusting;
}

void GridCharacteristics::setOffLoadHoliday (double offLoadHoliday){
    this->offLoadHoliday = offLoadHoliday;
}

void GridCharacteristics::setHolidayLoad (vector<double>& holidayLoad) {
    this->holidayLoad = holidayLoad;
}

void GridCharacteristics::setWeekdayLoad (vector<double>& weekdayLoad) {
    this->weekdayLoad = weekdayLoad;
}

void GridCharacteristics::setCalendar (Calendar* calendar) {
    this->calendar = calendar;
}
