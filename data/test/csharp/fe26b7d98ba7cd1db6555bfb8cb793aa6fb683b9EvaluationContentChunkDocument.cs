using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AcceptApi.Areas.Api.Models.Evaluation
{
    public class EvaluationContentChunkDocument
    {        
        public List<ContentChunk> chunkList { get; set; }
        public EvaluationContentChunkDocument()
        {           
            this.chunkList = new List<ContentChunk>();
        }
    }

    public class ContentChunk
    {
        public string chunk { get; set; }
        public int active { get; set; }
        public string chunkInfo { get; set; }

        public ContentChunk()
        {
            this.chunk = string.Empty;
            this.active = 1;
            this.chunkInfo = string.Empty;
        }

    }

}