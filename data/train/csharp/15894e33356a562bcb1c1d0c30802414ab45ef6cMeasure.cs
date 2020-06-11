using System.Collections.Generic;
using UnityEngine;

namespace MusicalRepresentation
{
    public class Measure : MonoBehaviour
    {
        public Row redRow;
        public Row orangeRow;
        public Row yellowRow;
        public Row greenRow;
        public Row blueRow;
        public Row purpleRow;

        private List<Row> _rowList;
        private System.DateTime _start;
        private Score _score;
        private RectTransform _rectTransform;
        private bool _isReset = true;

        private void Awake()
        {
            _score = this.transform.GetComponentInParent<Score>();
            _rectTransform = (RectTransform) this.transform;

            _rowList = new List<Row>();

            foreach (var instrument in InstrumentHelper.GetInstrumentList())
            {
                var row = GetRowForInstrument(instrument);
                if (row != null)
                {
                    _rowList.Add(row);
                }
            }
        }

        // Use this for initialization
        void Start()
        {
            foreach (var instrument in InstrumentHelper.GetInstrumentList())
            {
                var row = GetRowForInstrument(instrument);
                row.Init(InstrumentHelper.GetColorForInstrument(instrument));
            }
        }

        public void Draw(float relativeTime)
        {
        
        }
    
        public Vector3 GetLocationForTime(float time)
        {
            var pos = this.transform.position;
            var xloc = Mathf.Lerp(_rectTransform.rect.xMin, _rectTransform.rect.xMax, time);
            pos.x += xloc;
            return pos;
        }

        public void ResetMeasure()
        {
            if (!_isReset)
            {
                _rowList.ForEach(x => x.Reset());
                _isReset = true;
            }
        }

        public bool IsMeasureCorrect()
        {
            return _rowList.TrueForAll(x => x.IsRowCorrect());
        }

        public void RecordHit(Instrument instrument, float relativeTime)
        {
            _isReset = false;
            GetRowForInstrument(instrument).RecordHit(relativeTime);
        }

        public Row GetRowForInstrument(Instrument instrument)
        {
            switch (instrument)
            {
                case Instrument.Red:
                    return redRow;
                case Instrument.Orange:
                    return orangeRow;
                case Instrument.Yellow:
                    return yellowRow;
                case Instrument.Green:
                    return greenRow;
                case Instrument.Blue:
                    return blueRow;
                case Instrument.Purple:
                    return purpleRow;
                default:
                    Debug.LogError("No row found for: " + instrument.ToString());
                    return null;
            }
        }

    }
}