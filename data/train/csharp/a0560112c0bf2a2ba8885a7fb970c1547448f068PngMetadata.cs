using System;
using System.Collections.Generic;
using System.Text;

namespace Hjg.Pngcs.Chunks
{
	internal class PngMetadata
	{
		private readonly ChunksList chunkList;
		private readonly bool ReadOnly;

		internal PngMetadata ( ChunksList chunks )
		{
			this.chunkList = chunks;
			if ( chunks is ChunksListForWrite )
			{
				this.ReadOnly = false;
			}
			else
			{
				this.ReadOnly = true;
			}
		}

		public void QueueChunk ( PngChunk chunk, bool lazyOverwrite )
		{
			ChunksListForWrite cl = getChunkListW ();
			if ( ReadOnly )
				throw new PngjException ( "cannot set chunk : readonly metadata" );
			if ( lazyOverwrite )
			{
				ChunkHelper.TrimList ( cl.GetQueuedChunks (), new ChunkPredicateEquiv ( chunk ) );
			}
			cl.Queue ( chunk );
		}

		public void QueueChunk ( PngChunk chunk )
		{
			QueueChunk ( chunk, true );
		}

		private ChunksListForWrite getChunkListW ()
		{
			return ( ChunksListForWrite ) chunkList;
		}

		public double [] GetDpi ()
		{
			PngChunk c = chunkList.GetById1 ( ChunkHelper.pHYs, true );
			if ( c == null )
				return new double [] { -1, -1 };
			else
				return ( ( PngChunkPHYS ) c ).GetAsDpi2 ();
		}

		public void SetDpi ( double dpix, double dpiy )
		{
			PngChunkPHYS c = new PngChunkPHYS ( chunkList.imageInfo );
			c.SetAsDpi2 ( dpix, dpiy );
			QueueChunk ( c );
		}

		public void SetDpi ( double dpi )
		{
			SetDpi ( dpi, dpi );
		}

		public PngChunkTIME SetTimeNow ( int nsecs )
		{
			PngChunkTIME c = new PngChunkTIME ( chunkList.imageInfo );
			c.SetNow ( nsecs );
			QueueChunk ( c );
			return c;
		}

		public PngChunkTIME SetTimeNow ()
		{
			return SetTimeNow ( 0 );
		}

		public PngChunkTIME SetTimeYMDHMS ( int year, int mon, int day, int hour, int min, int sec )
		{
			PngChunkTIME c = new PngChunkTIME ( chunkList.imageInfo );
			c.SetYMDHMS ( year, mon, day, hour, min, sec );
			QueueChunk ( c, true );
			return c;
		}

		public PngChunkTIME GetTime ()
		{
			return ( PngChunkTIME ) chunkList.GetById1 ( ChunkHelper.tIME );
		}

		public String GetTimeAsString ()
		{
			PngChunkTIME c = GetTime ();
			return c == null ? "" : c.GetAsString ();
		}

		public PngChunkTextVar SetText ( String key, String val, bool useLatin1, bool compress )
		{
			if ( compress && !useLatin1 )
				throw new PngjException ( "cannot compress non latin text" );
			PngChunkTextVar c;
			if ( useLatin1 )
			{
				if ( compress )
				{
					c = new PngChunkZTXT ( chunkList.imageInfo );
				}
				else
				{
					c = new PngChunkTEXT ( chunkList.imageInfo );
				}
			}
			else
			{
				c = new PngChunkITXT ( chunkList.imageInfo );
				( ( PngChunkITXT ) c ).SetLangtag ( key ); // we use the same orig tag (this is not quite right)
			}
			c.SetKeyVal ( key, val );
			QueueChunk ( c, true );
			return c;
		}

		public PngChunkTextVar SetText ( String key, String val )
		{
			return SetText ( key, val, false, false );
		}

		public List<PngChunkTextVar> GetTxtsForKey ( String key )
		{
			List<PngChunkTextVar> li = new List<PngChunkTextVar> ();
			foreach ( PngChunk c in chunkList.GetById ( ChunkHelper.tEXt, key ) )
				li.Add ( ( PngChunkTextVar ) c );
			foreach ( PngChunk c in chunkList.GetById ( ChunkHelper.zTXt, key ) )
				li.Add ( ( PngChunkTextVar ) c );
			foreach ( PngChunk c in chunkList.GetById ( ChunkHelper.iTXt, key ) )
				li.Add ( ( PngChunkTextVar ) c );
			return li;
		}

		public String GetTxtForKey ( String key )
		{
			String t = "";
			List<PngChunkTextVar> li = GetTxtsForKey ( key );
			if ( li.Count == 0 )
				return t;
			foreach ( PngChunkTextVar c in li )
				t = t + c.GetVal () + "\n";
			return t.Trim ();
		}

		public PngChunkPLTE GetPLTE ()
		{
			return ( PngChunkPLTE ) chunkList.GetById1 ( PngChunkPLTE.ID );
		}

		public PngChunkPLTE CreatePLTEChunk ()
		{
			PngChunkPLTE plte = new PngChunkPLTE ( chunkList.imageInfo );
			QueueChunk ( plte );
			return plte;
		}

		public PngChunkTRNS GetTRNS ()
		{
			return ( PngChunkTRNS ) chunkList.GetById1 ( PngChunkTRNS.ID );
		}

		public PngChunkTRNS CreateTRNSChunk ()
		{
			PngChunkTRNS trns = new PngChunkTRNS ( chunkList.imageInfo );
			QueueChunk ( trns );
			return trns;
		}
	}
}
