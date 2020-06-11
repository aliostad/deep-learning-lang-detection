using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework;
using System.Xml.Serialization;
using TheGrid.Model.Instrument;

namespace TheGrid.Model
{
    [Serializable]
    public class Cell
    {
        [XmlIgnore]
        public Map Map { get; set; }
        public Point Coord { get; set; }
        public Vector2 Location { get; set; }
        public Vector2 InitialLocation { get; set; }
        [XmlIgnore]
        public Cell[] Neighbourghs { get; set; }
        public Clip Clip { get; set; }
        public Channel Channel { get; set; }
        public float[] Life { get; set; }
        [XmlIgnore]
        public List<TimeValue<Vector2>> ListWave { get; set; }
        [XmlIgnore]
        public float Size { get; set; }

        public Cell() 
        {
            this.ListWave = new List<TimeValue<Vector2>>();
            this.Size = 1f;
        }

        public Cell(Map map, int x, int y, float left, float top)
        {
            this.Map = map;
            this.Coord = new Point(x, y);
            this.Location = new Vector2(left, top);
            this.InitialLocation = new Vector2(left, top);
            this.ListWave = new List<TimeValue<Vector2>>();
            this.Size = 1f;

            this.Neighbourghs = new Cell[6];
        }

        public int IndexPosition
        {
            get
            {
                return (this.Coord.Y - 1) * this.Map.Width + this.Coord.X - 1;
            }
        }

        public override string ToString()
        {
            return String.Format("{0} : {1},{2}", IndexPosition, Coord.X, Coord.Y);
        }

        public void InitClip()
        {
            if (Clip == null)
                Clip = new Clip();
        }

        public Cell GetDirection(int direction, int iteration)
        {
            Cell cell = this;
            for (int i = 0; i < iteration && cell != null; i++)
            {
                cell = cell.Neighbourghs[direction];
            }

            return cell;
        }

        public void Clone(Cell cellOrigin)
        {
            cellOrigin.Clip = null;
            
            cellOrigin.Channel = this.Channel;

            if (this.Clip != null)
            {
                cellOrigin.Clip = new Clip();

                for (int i = 0; i < 6; i++)
                {
                    cellOrigin.Clip.Directions[i] = this.Clip.Directions[i];
                }

                cellOrigin.Clip.Repeater = this.Clip.Repeater;
                cellOrigin.Clip.Speed = this.Clip.Speed;
                cellOrigin.Clip.Duration = this.Clip.Duration;

                if (this.Clip.Instrument != null)
                {
                    if (this.Clip.Instrument is InstrumentSample)
                    {
                        cellOrigin.Clip.Instrument = new InstrumentSample(((InstrumentSample)this.Clip.Instrument).Sample);
                    }
                    else if (this.Clip.Instrument is InstrumentEffect)
                    {
                        cellOrigin.Clip.Instrument = new InstrumentEffect(((InstrumentEffect)this.Clip.Instrument).ChannelEffect);
                    }
                    else if (this.Clip.Instrument is InstrumentStart)
                    {
                        cellOrigin.Clip.Instrument = new InstrumentStart();
                        
                        this.Clip.Instrument = null;
                        this.Channel.CellStart = cellOrigin;
                    }
                    else if (this.Clip.Instrument is InstrumentStop)
                    {
                        cellOrigin.Clip.Instrument = new InstrumentStop();
                    }
                    else if (this.Clip.Instrument is InstrumentNote)
                    {
                        cellOrigin.Clip.Instrument = new InstrumentNote(((InstrumentNote)this.Clip.Instrument).NoteKey, ((InstrumentNote)this.Clip.Instrument).NoteName);
                    }
                    else if (this.Clip.Instrument is InstrumentCapture)
                    {
                        cellOrigin.Clip.Instrument = new InstrumentCapture(((InstrumentCapture)this.Clip.Instrument).Sample);
                    }
                }
            }
        }
    }
}
