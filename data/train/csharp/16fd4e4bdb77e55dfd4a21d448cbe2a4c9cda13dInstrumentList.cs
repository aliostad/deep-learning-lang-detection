// Licensed under the Apache License, Version 2.0. 
// Copyright (c) Alex Lee. All rights reserved.

using System;
using System.Collections.Generic;
using System.Collections;

namespace SmartQuant
{
	public class InstrumentList : IEnumerable<Instrument>
	{
		private List<Instrument> instruments = new List<Instrument>();

		public IEnumerator<Instrument> GetEnumerator()
		{
			return this.instruments.GetEnumerator();
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			return this.instruments.GetEnumerator();
		}
	}
}

