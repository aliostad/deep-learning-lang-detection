SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/**************************************************************
 Data navigational stored procedure for bin maintenance keys
 Parameters:
	@table_name - name of bin maintanance tablen to navigate
	@field_name - field to navigate (must be a primary key)
	@nav_type - type of navigation requested
		F - First, P - Previous, N - Next, L - Last
	@current_val - the current key value to reference when 
		performing referential navigation (next/prev)
***************************************************************/
CREATE PROCEDURE [dbo].[tdc_navigate_bin2bin_sp] (
	@field_name varchar(30),
	@nav_type varchar(1),
	@current_val varchar(255)
)
AS

SET NOCOUNT ON

DECLARE @SQL varchar(255)

IF @field_name = 'tran_id'
  BEGIN
    IF @nav_type = 'F'
      BEGIN
        SELECT MIN(tran_id) FROM tdc_pick_queue WHERE trans = 'MGTB2B'
      END

    IF @nav_type = 'P'
      BEGIN
        IF EXISTS(SELECT tran_id FROM tdc_pick_queue WHERE tran_id < @current_val AND trans = 'MGTB2B')
            SELECT MAX(tran_id) FROM tdc_pick_queue 
            WHERE tran_id < @current_val AND trans = 'MGTB2B'
        ELSE
            SELECT MIN(tran_id) FROM tdc_pick_queue WHERE trans = 'MGTB2B'
      END

    IF @nav_type = 'N'
      BEGIN
        IF EXISTS(SELECT tran_id FROM tdc_pick_queue WHERE tran_id > @current_val AND trans = 'MGTB2B')
            SELECT MIN(tran_id) FROM tdc_pick_queue 
            WHERE tran_id > @current_val AND trans = 'MGTB2B'
        ELSE
            SELECT MAX(tran_id) FROM tdc_pick_queue WHERE trans = 'MGTB2B'
      END

    IF @nav_type = 'L'
      BEGIN
        SELECT MAX(tran_id) FROM tdc_pick_queue WHERE trans = 'MGTB2B'
      END
    return 0
  END

IF @field_name = 'location'
  BEGIN
    IF @nav_type = 'F'
      BEGIN
        SELECT MIN(location) FROM locations
      END

    IF @nav_type = 'P'
      BEGIN
        IF EXISTS(SELECT location FROM locations WHERE location < @current_val)
            SELECT MAX(location) FROM locations 
            WHERE location < @current_val
        ELSE
            SELECT MIN(location) FROM locations
      END

    IF @nav_type = 'N'
      BEGIN
        IF EXISTS(SELECT location FROM locations WHERE location > @current_val)
            SELECT MIN(location) FROM locations 
            WHERE location > @current_val
        ELSE
            SELECT MAX(location) FROM locations
      END

    IF @nav_type = 'L'
      BEGIN
        SELECT MAX(location) FROM locations
      END
    return 0
  END
GO
GRANT EXECUTE ON  [dbo].[tdc_navigate_bin2bin_sp] TO [public]
GO
