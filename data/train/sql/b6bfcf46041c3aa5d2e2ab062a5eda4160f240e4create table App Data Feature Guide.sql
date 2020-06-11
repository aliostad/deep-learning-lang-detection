/*
Table of data to return to client, after completing a successful search.
September 2014
*/

USE Gazetteer;
GO
IF OBJECT_ID('AppData.FeatureGuide') IS NOT NULL
    DROP TABLE AppData.FeatureGuide;

CREATE TABLE AppData.FeatureGuide
(
FeatureGuide_pk  INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_FeatureGuide PRIMARY KEY,
FeatureID INT NOT NULL,                                        --one record per feature ID
FeatureName VARCHAR(120) NOT NULL,            --"official" feature name
StateName VARCHAR(40) NOT NULL,                  --full state name, as opposed to Postal Code
AltermativeNameList VARCHAR(MAX) NOT NULL,  -- append together all unofficial names names, in date order (per [Citiation], on [date] in (if known, not 1899).
FeatureDescription VARCHAR(3000) NOT NULL,
FeatureHistory  VARCHAR(3000) NOT NULL,
FeatureCitation  VARCHAR(4000) NOT NULL,     -- the "official" entry in the All Names table
DisplayOnMapFlag BIT NOT NULL,                       --from the "Consise" table
ElevationInMeters INT NOT NULL,
DateCreated DATE NOT NULL,                                  --per USGS
DateEdited  DATE NOT NULL                                    --per USGS
)
ON Secondary;
GO





