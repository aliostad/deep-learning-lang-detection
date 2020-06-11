using System;
using System.Text;
using System.ComponentModel;
using System.Windows.Forms;

namespace WaveformView.Chunks
{
    class Riff : Chunk
    {
        const string m_chunkName = "Riff Chunk";

        readonly string m_chunkID;
        readonly UInt32 m_chunkSize;
        readonly string m_format;

        readonly ChunkCollection m_chunkCollection = new ChunkCollection();

        public Riff( UInt32 size, Byte [] data )
        {
            Int32 pos = 0;

            m_chunkID = Encoding.ASCII.GetString( data, pos, 4 );
            pos += 4;
            m_chunkSize = BitConverter.ToUInt32( data, pos );
            pos += 4;
            m_format = Encoding.ASCII.GetString( data, pos, 4 );
            pos += 4;

            if ( "RIFF" != m_chunkID )
            {
                MessageBox.Show( "Unsupported header format \"" + m_chunkID + "\". Quitting.",
                    "Error!",
                    MessageBoxButtons.OK );
                Application.Exit();
            }

            if ( "WAVE" != m_format )
            {
                MessageBox.Show( "Unsupported data format \"" + m_format + "\". Quitting.", 
                    "Error!", MessageBoxButtons.OK );
                Application.Exit();
            }

            while ( pos < m_chunkSize )
            {
                string chunkType = Encoding.ASCII.GetString( data, pos, 4 );
                pos += 4;
                UInt32 chunkSize = BitConverter.ToUInt32( data, pos );
                pos += 4;

                if ( chunkSize % 2 == 1 )
                {
                    pos += 1;
                }

                if ( m_chunkSize < pos )
                {
                    break;
                }

                Byte[] chunkData = new Byte[chunkSize];
                Array.Copy(data, pos, chunkData, 0, chunkSize);
                Chunk nextChunk = ChunkFactory.CreateChunk( chunkType, chunkSize, chunkData );

                if ( nextChunk != null )
                {
                    m_chunkCollection.Add( nextChunk );
                }

                pos += (Int32)chunkSize;
            }
        }

        public override string Name
        {
            get { return m_chunkName; }
            set { }
        }

        [CategoryAttribute( m_chunkName )]
        [DisplayName( "Chunk ID" )]
        public string ChunkId
        {
            set { }
            get { return m_chunkID; }
        }

        [CategoryAttribute( m_chunkName )]
        [DisplayName( "Chunk Size" )]
        public UInt32 ChunkSize
        {
            set { }
            get { return m_chunkSize; }
        }

        [CategoryAttribute( m_chunkName )]
        [DisplayName( "Data Format" )]
        public string Format
        {
            set { }
            get { return m_format; }
        }

        [CategoryAttribute( m_chunkName )]
        [DisplayName( "Chunks" )]
        [TypeConverter(typeof( ChunkCollectionConverter ) )]
        public ChunkCollection ChunkCollections
        {
            set { }
            get { return m_chunkCollection; }
        }
    }
}
