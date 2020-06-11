using System.Collections.Generic;
using com.gm.cat.geets.domain;

namespace com.gm.cat.geets.application {
    public interface IGeetsApplication {
        IInventoryExRepository InventoryEx();
        IInventoryRepository Inventory();
        ICalibrationRepository Calibration();
        ICalLabLimitExcursionRepository CalLabLimitExcursionRepository();
        ICalLabTempAndHumidStationRepository CalLabTempAndHumidStationRepository();
        ICalLabTempAndHumidRepository CalLabTempAndHumidRepository();
        ICC_AnalysisResultsRepository CC_AnalysisResultsRepository();
        ICC_BridgeAxisCalRepository CC_BridgeAxisCalRepository();
        ISecurityRepository SecurityRepository();

        ICcTransducerRepository CcTransducerRepository();
        IAoUnitRepository AoUnitRepository();
        IAoPhysicalDimensionRepository AoPhysicalDimensionRepository();
        ICcAxisInfoRepository CcAxisInfoRepository();
        ICcCriteriaListRepository CcCriteriaListRepository();
        ICcIrTraccAxisInfoRepository CcIrTraccAxisInfoRepository();
        IAoLnk_Unit_UnitGroupRepository AoLnk_Unit_UnitGroupRepository();
        IAoUnitGroupRepository AoUnitGroupRepository();
        ICC_ProgSettingsRepository CC_ProgSettingsRepository();
        IUserlistRepository UserlistRepository();
        ICC_lnkStandardListRepository CC_lnkStandardListRepository();
        IStandardRepository StandardRepository();
        IResultRepository ResultRepository();
        IResultRawRepository ResultRawRepository();
        ICcAccelAxisInfoRepository CcAccelAxisInfoRepository();
        IStandardListRepository StandardListRepository();
        ICC_SafetyRepository CC_SafetyRepository();
        IGrouplistRepository GrouplistRepository();
        IValFieldRepository ValFieldRepository();
        ICC_UnitsOfMeasurementRepository CC_UnitsOfMeasurementRepository();
    }
}
