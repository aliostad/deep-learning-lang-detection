import os
from common import tiff_save


def config_subparser(hillshade_parser):
    hillshade_parser.add_argument("-s", required=True)
    hillshade_parser.add_argument("-z", required=True)
    hillshade_parser.add_argument("--alt", required=True)

def process(parsed, target, temp_metatile, temp_processed, save_offsetx, save_offsety, save_xsize, save_ysize, nodata, ot, *args, **kwargs):

    scale = parsed.s
    zfactor = parsed.z
    altitude = parsed.alt
    process_hillshade = "gdaldem hillshade -s %s -z %s -alt %s %s -of GTiff %s > /dev/null" %(scale, zfactor, altitude, temp_metatile, temp_processed)
    #print process_hillshade
    os.system(process_hillshade)
    tiff_save(temp_processed, target, save_offsetx, save_offsety, save_xsize, save_ysize, nodata, ot)