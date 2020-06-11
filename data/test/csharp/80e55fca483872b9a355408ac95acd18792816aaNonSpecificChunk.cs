using System.Collections.Generic;
using System.Linq;
using ApiResponse;
using Peto.Models;

namespace Peto.OCR.Chunks {
    //public delegate ChunkIdentifierModel GetIdentityFromUser(List<ChunkIdentifierModel> listOfIdentifiers, NonSpecificChunk chunk);

    public class NonSpecificChunk : Chunk {
        public NonSpecificChunk(string content) : base(content) { }
        //public NonSpecificChunk(string content) : base(content) { }

        /// <summary>
        /// Used to get and set the ChunkModel of the chunk.
        /// </summary>
        private ChunkModel ChunkModel { get; set; }

        public List<ChunkIdentifierModel> PossibleIdentities { get; private set; }

        //public event GetIdentityFromUser PromptUserForIdentity;
       
        public Chunk SpecifyChunk() {
            List<ChunkIdentifierModel> _identifiers = IdentifyChunk();
            ChunkIdentifierModel _chunkIdentity = null;
            Chunk chunk = this;
            if(_identifiers.Count == 1) {
                _chunkIdentity = _identifiers.First();

                switch (_chunkIdentity.Type) {
                    case ChunkType.Email:
                        chunk = new EmailChunk(this.Content, _chunkIdentity.Type);
                        break;
                    case ChunkType.Name:
                        chunk = new NameChunk(this.Content, _chunkIdentity.Type);
                        break;
                    case ChunkType.Phone:
                        chunk = new PhoneChunk(this.Content, _chunkIdentity.Type);
                        break;
                    case ChunkType.Firm:
                        chunk = new FirmChunk(this.Content, _chunkIdentity.Type);
                        break;
                }
            }
            else if (_identifiers.Count == 0) {
                this.PossibleIdentities = GetIdentifiers();
            }
            else {
                this.PossibleIdentities = _identifiers;
            }

            return chunk;
        }

        private List<ChunkIdentifierModel> IdentifyChunk() {
            List<ChunkIdentifierModel> _identifiers = this.GetIdentifiers();
            return _identifiers.Where(ci => ci.Identity.Match(this.Content).Success).ToList();
        }

        private List<ChunkIdentifierModel> GetIdentifiers() {
            return (from ci in OCRRunner.Instance.Db.ChunkIdentifiers
                    select ci).ToList();
        }
    }
}
