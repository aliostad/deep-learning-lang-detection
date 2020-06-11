// The MIT License (MIT)
// 
// Copyright (c) 2015 Filip Frącz
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BasicallyMe.RobinhoodNet.Helpers
{
    public class InstrumentCache
    {
        readonly RobinhoodClient _client;
        readonly Dictionary<string, Instrument> _symbolToInstrument;
        readonly Dictionary<string, Instrument> _instrumentKeyToIntrument;


        public InstrumentCache (RobinhoodClient client)
        {
            _client = client;
            _symbolToInstrument = new Dictionary<string, Instrument>();
            _instrumentKeyToIntrument = new Dictionary<string, Instrument>();
        }

        void addInstrument (Instrument instrument)
        {
            _symbolToInstrument[instrument.Symbol] = instrument;
            _instrumentKeyToIntrument[instrument.InstrumentUrl.ToString()] = instrument;
        }

        public async Task<Instrument> GetInstrument (Url<Instrument> instrumentUrl)
        {
            Instrument instrument = null;
            if (!_instrumentKeyToIntrument.TryGetValue(instrumentUrl.ToString(), out instrument))
            {
                instrument = await _client.DownloadInstrument(instrumentUrl);
                addInstrument(instrument);
            }
            return instrument;
        }

        public async Task<Instrument> GetInstrument (string symbol)
        {
            Instrument instrument = null;
            if (!_symbolToInstrument.TryGetValue(symbol, out instrument))
            {
                // Find the instrument
                var list = await _client.FindInstrument(symbol);
                instrument = list.First(i => i.Symbol == symbol);
                addInstrument(instrument);
            }

            return instrument;
        }

        public Task<string> GetSymbol (Url<Instrument> instrumentUrl)
        {
            return this.GetSymbol(instrumentUrl.ToString());
        }

        public async Task<string> GetSymbol (string instrumentUrl)
        {
            Instrument instrument = null;
            if (!_instrumentKeyToIntrument.TryGetValue(instrumentUrl, out instrument))
            {
                instrument = await _client.DownloadInstrument(new Url<Instrument>(instrumentUrl));
                addInstrument(instrument);
            }
            return instrument.Symbol;
        }
    }
}
