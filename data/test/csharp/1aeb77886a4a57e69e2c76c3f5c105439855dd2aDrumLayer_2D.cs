using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media;
using Microsoft.Kinect;

namespace KinectDrumMod
{
    class DrumLayer_2D
    {
        private DrawingGroup drawingGroup = null;
        private double instrumentX = 50;
        private double instrumentY = 50;
        private double instrumentWidth = 150;
        private double instrumentHeight = 75;
        private double touchOffsetLeftX = 0;
        private double touchOffsetLeftY = 0;
        private double touchOffsetRightX = 0;
        private double touchOffsetRightY = 0;
        private const double instrumentEdge = 20;
        private const double stretchBreakThreshold = 20;
        private KinectSensor sensor = null;

        private bool holdingInstrument = false;
        private bool stretchingVertically = false;
        private bool stretchingHorizontally = false;

        public Skeleton trackingSkeleton = null;
        public event EventHandler<PlayingDrumEventArgs> PlayingDrum;
        public DrumLayer_2D(DrawingGroup drawingGroup, KinectSensor sensor)
        {
            this.drawingGroup = drawingGroup;
            this.sensor = sensor;
        }
        public double getX(){
            return instrumentX;
        }
        public double getY(){
            return instrumentY;
        }
        public double getWidth()
        {
            return instrumentWidth;
        }
        public double getHeight()
        {
            return instrumentHeight;
        }
        public void SkeletonDrawingFinished(object sender, SkeletonDrawingFinishedEventArgs e)
        {
            //instrument interaction
            Brush brush = Brushes.Tomato;
            using (DrawingContext dc = this.drawingGroup.Open())
            {
                dc.DrawRectangle(Brushes.Transparent, null, new Rect(0.0, 0.0, 640, 480));
                Skeleton trackingSkel = e.LastTracked;
                if (trackingSkel != null)
                {
                    Joint joint = trackingSkel.Joints[JointType.HandLeft];
                    Point leftHand = SkeletonPointToScreen(joint.Position);

                    joint = trackingSkel.Joints[JointType.HandRight];
                    Point rightHand = SkeletonPointToScreen(joint.Position);

                    if (isTouchingInstrumentEdgeRight(rightHand) || isTouchingInstrumentBody(rightHand) || isTouchingInstrumentEdgeTop(rightHand))
                    {
                        holdingInstrument = false;
                    }
                    else if (!holdingInstrument && isTouchingInstrumentBody(leftHand))
                    {
                        holdingInstrument = true;
                        touchOffsetLeftX = leftHand.X - instrumentX;
                        touchOffsetLeftY = leftHand.Y - instrumentY;
                    }
                    if (isTouchingInstrumentEdgeRight(rightHand))
                    {
                        brush = Brushes.Violet;
                    }
                    if (isTouchingInstrumentEdgeTop(rightHand))
                    {
                        brush = Brushes.Yellow;
                    }
                    if (isTouchingInstrumentEdgeTop(leftHand) || isTouchingInstrumentEdgeTop(rightHand))
                    {
                        PlayingDrumEventArgs args = new PlayingDrumEventArgs();
                        args.DrumHeight = instrumentHeight;
                        args.DrumWidth = instrumentWidth;
                        args.Velocity = 0;
                        OnPlayingDrum(args);
                    }

                    if (stretchingHorizontally && Math.Abs(rightHand.Y - leftHand.Y) >= stretchBreakThreshold)
                    {
                        stretchingHorizontally = false;
                    }
                    else if (isTouchingInstrumentEdgeLeft(leftHand) && isTouchingInstrumentEdgeRight(rightHand))
                    {
                        stretchingHorizontally = true;
                        stretchingVertically = false;
                    }

                    if (stretchingVertically && Math.Abs(rightHand.X - leftHand.X) >= instrumentWidth)
                    {
                        stretchingVertically = false;
                    }
                    else if (isTouchingInstrumentEdgeTop(rightHand) && isTouchingInstrumentEdgeBottom(leftHand))
                    {
                        stretchingVertically = true;
                        stretchingHorizontally = false;
                    }

                    if (stretchingHorizontally)
                    {
                        brush = Brushes.SteelBlue;
                        instrumentWidth = Math.Abs(rightHand.X - leftHand.X);
                        instrumentX = leftHand.X;
                    }
                    if (stretchingVertically)
                    {
                        brush = Brushes.SkyBlue;
                        instrumentHeight = Math.Abs(leftHand.Y - rightHand.Y);
                        instrumentY = rightHand.Y;
                    }
                    if (holdingInstrument)
                    {
                        brush = Brushes.SpringGreen;
                        instrumentX = leftHand.X - touchOffsetLeftX;
                        instrumentY = leftHand.Y - touchOffsetLeftY;
                    }
                    if (holdingInstrument && stretchingHorizontally)
                    {
                        brush = Brushes.PeachPuff;
                    }
                    //Console.WriteLine("Hand: " + leftHand.X + "," + leftHand.Y);
                    //Console.WriteLine("Instrument: " + instrumentX + "," + instrumentY);
                }
                instrumentWidth = (instrumentWidth > instrumentEdge * 2 + 10) ? instrumentWidth : instrumentEdge * 2 + 10;
                instrumentHeight = (instrumentHeight > instrumentEdge * 2 + 10) ? instrumentHeight : instrumentEdge * 2 + 10;
                dc.DrawRectangle(brush, null, new Rect(instrumentX, instrumentY, instrumentWidth, instrumentHeight));
            }
        }
        private Point SkeletonPointToScreen(SkeletonPoint skelpoint)
        {
            DepthImagePoint depthPoint = this.sensor.CoordinateMapper.MapSkeletonPointToDepthPoint(skelpoint, DepthImageFormat.Resolution640x480Fps30);
            return new Point(depthPoint.X, depthPoint.Y + 10);
        }

        private bool isTouchingInstrumentEdgeLeft(Point point)
        {
            double x = point.X;
            double y = point.Y;
            double diff = x - instrumentX;
            return (diff <= instrumentEdge && diff >= 0 &&
                y >= instrumentY && y <= instrumentY + instrumentHeight) ? true : false;
        }
        private bool isTouchingInstrumentEdgeRight(Point point)
        {
            double x = point.X;
            double y = point.Y;
            double diff = (instrumentX + instrumentWidth) - x;
            return (diff <= instrumentEdge && diff >= 0 &&
                y >= instrumentY && y <= instrumentY + instrumentHeight) ? true : false;
        }
        private bool isTouchingInstrumentEdgeTop(Point point)
        {
            double x = point.X;
            double y = point.Y;
            double diff = y - instrumentY;
            return (diff <= instrumentEdge && diff >= 0 &&
                x >= instrumentX && x <= instrumentX + instrumentWidth) ? true : false;
        }
        private bool isTouchingInstrumentEdgeBottom(Point point)
        {
            double x = point.X;
            double y = point.Y;
            double diff = (instrumentY + instrumentHeight) - y;
            return (diff <= instrumentEdge && diff >= 0 &&
                x >= instrumentX && x <= instrumentX + instrumentWidth) ? true : false;
        }
        private bool isTouchingInstrumentBody(Point point)
        {
            double x = point.X;
            double y = point.Y;
            return (x > instrumentX + instrumentEdge && x < instrumentX + instrumentWidth - instrumentEdge &&
                y > instrumentY + instrumentEdge && y < instrumentY + instrumentHeight - instrumentEdge) ? true : false;
        }

        protected virtual void OnPlayingDrum(PlayingDrumEventArgs e)
        {
            EventHandler<PlayingDrumEventArgs> handler = PlayingDrum;
            if (handler != null)
            {
                handler(this, e);
            }
        }
    }

    public class PlayingDrumEventArgs : EventArgs
    {
        public double DrumWidth { get; set; }
        public double DrumHeight { get; set; }
        public double Velocity { get; set; }
    }
}
