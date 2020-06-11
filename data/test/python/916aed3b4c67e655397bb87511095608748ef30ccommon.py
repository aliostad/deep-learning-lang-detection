import os
import osgeo.gdal as gdal
import osgeo.gdalconst as gdalconst
from osgeo.gdalconst import *
import osr
import numpy




def tiff_save(temp_processed, target, save_offsetx, save_offsety, save_xsize, save_ysize, nodata, ot):
    save_tile = "gdal_translate -co compress=lzw %s -of GTiff %s -srcwin %s %s %s %s -a_nodata %s %s > /dev/null" %(temp_processed, target, save_offsetx, save_offsety, save_xsize, save_ysize, nodata, ot)
    #print save_tile
    os.system(save_tile)

def numpy_read(gtiff):
    temp_ds = gdal.Open(gtiff, GA_ReadOnly)
    temp_geotransform = temp_ds.GetGeoTransform()

    temp_band = temp_ds.GetRasterBand(1)
    temp_nodata = int(temp_band.GetNoDataValue() or 0)
    temp_data = numpy.array(temp_band.ReadAsArray())

    return temp_ds, temp_geotransform, temp_band, temp_nodata, temp_data

def numpy_save(processed_numpy, target, save_offsetx, save_offsety, save_xsize, save_ysize, geotransform_original, nodata, ot):

    cut_array = processed_numpy[save_offsety:save_offsety + save_ysize, save_offsetx:save_offsetx + save_xsize]

    geotransform = [
        geotransform_original[0] + geotransform_original[1] * save_offsetx,
        geotransform_original[1],
        geotransform_original[2],
        geotransform_original[3] + geotransform_original[5] * save_offsety,
        geotransform_original[4],
        geotransform_original[5]
    ]
    # !! DIRTY: output type set to Int16
    output_raster = gdal.GetDriverByName('GTiff').Create(target, save_xsize, save_ysize, 1, gdal.GDT_Int16)  # Open the file
    output_raster.SetGeoTransform(geotransform)  # Specify its coordinates
    srs = osr.SpatialReference()                 # Establish its coordinate encoding
    srs.ImportFromEPSG(4326)                     # This one specifies WGS84 lat long.
                                                 # Anyone know how to specify the 
                                                 # IAU2000:49900 Mars encoding?
    output_raster.SetProjection( srs.ExportToWkt() )   # Exports the coordinate system 
                                                       # to the file
    output_raster.GetRasterBand(1).WriteArray(cut_array)   # Writes my array to the raster
