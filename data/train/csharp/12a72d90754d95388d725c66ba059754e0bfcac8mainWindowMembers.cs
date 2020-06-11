using AForge.Video;
using CamRecord2;
using Emgu.CV;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using WPFSpark;

namespace vipbug2
{
    partial class MainWindow : SparkWindow
    {
        List<string> modules = new List<String> 
        {
            CvInvoke.OPENCV_CORE_LIBRARY
            ,CvInvoke.OPENCV_IMGPROC_LIBRARY

            ,CvInvoke.OPENCV_VIDEO_LIBRARY
            //,CvInvoke.OPENCV_FLANN_LIBRARY
            //,CvInvoke.OPENCV_ML_LIBRARY

            //,CvInvoke.OPENCV_HIGHGUI_LIBRARY
            //,CvInvoke.OPENCV_OBJDETECT_LIBRARY
            //,CvInvoke.OPENCV_FEATURES2D_LIBRARY
            //,CvInvoke.OPENCV_CALIB3D_LIBRARY
              
            //,CvInvoke.OPENCV_LEGACY_LIBRARY

            //,CvInvoke.OPENCV_CONTRIB_LIBRARY
            //,CvInvoke.OPENCV_NONFREE_LIBRARY
            //,CvInvoke.OPENCV_PHOTO_LIBRARY
            //,CvInvoke.OPENCV_VIDEOSTAB_LIBRARY
 
            //,CvInvoke.OPENCV_FFMPEG_LIBRARY 
            //,CvInvoke.OPENCV_GPU_LIBRARY 
            //,CvInvoke.OPENCV_STITCHING_LIBRARY
            
            //,CvInvoke.EXTERN_GPU_LIBRARY
            //,CvInvoke.EXTERN_LIBRARY
        };

        Ipcam camControl;
        MJPEGStream ipcStream = new MJPEGStream();
        Bitmap ipcFrame;

    }
}
