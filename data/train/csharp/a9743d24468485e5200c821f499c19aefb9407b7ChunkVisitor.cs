// Copyright (c) .NET Foundation. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.Razor;
using Microsoft.AspNetCore.Mvc.RazorPages.Razevolution.Directives;
using Microsoft.AspNetCore.Razor.Chunks;
using Microsoft.AspNetCore.Razor.CodeGenerators.Visitors;

namespace Microsoft.AspNetCore.Mvc.RazorPages.Razevolution.IR
{
    public class ChunkVisitor : IChunkVisitor
    {
        public void Accept(IList<Chunk> chunks)
        {
            if (chunks == null)
            {
                throw new ArgumentNullException(nameof(chunks));
            }

            foreach (Chunk chunk in chunks)
            {
                Accept(chunk);
            }
        }

        public virtual void Accept(Chunk chunk)
        {
            if (chunk == null)
            {
                throw new ArgumentNullException(nameof(chunk));
            }

            // TODO: These should be replaced by a generic directive chunk.
            if (chunk is InjectChunk)
            {
                Visit((InjectChunk)chunk);
            }
            else if (chunk is ModelChunk)
            {
                Visit((ModelChunk)chunk);
            }
            else if (chunk is LiteralChunk)
            {
                Visit((LiteralChunk)chunk);
            }
            else if (chunk is ParentLiteralChunk)
            {
                Visit((ParentLiteralChunk)chunk);
            }
            else if (chunk is ExpressionBlockChunk)
            {
                Visit((ExpressionBlockChunk)chunk);
            }
            else if (chunk is ExpressionChunk)
            {
                Visit((ExpressionChunk)chunk);
            }
            else if (chunk is StatementChunk)
            {
                Visit((StatementChunk)chunk);
            }
            else if (chunk is TagHelperChunk)
            {
                Visit((TagHelperChunk)chunk);
            }
            else if (chunk is TagHelperPrefixDirectiveChunk)
            {
                Visit((TagHelperPrefixDirectiveChunk)chunk);
            }
            else if (chunk is AddTagHelperChunk)
            {
                Visit((AddTagHelperChunk)chunk);
            }
            else if (chunk is RemoveTagHelperChunk)
            {
                Visit((RemoveTagHelperChunk)chunk);
            }
            else if (chunk is TypeMemberChunk)
            {
                Visit((TypeMemberChunk)chunk);
            }
            else if (chunk is UsingChunk)
            {
                Visit((UsingChunk)chunk);
            }
            else if (chunk is SetBaseTypeChunk)
            {
                Visit((SetBaseTypeChunk)chunk);
            }
            else if (chunk is DynamicCodeAttributeChunk)
            {
                Visit((DynamicCodeAttributeChunk)chunk);
            }
            else if (chunk is LiteralCodeAttributeChunk)
            {
                Visit((LiteralCodeAttributeChunk)chunk);
            }
            else if (chunk is CodeAttributeChunk)
            {
                Visit((CodeAttributeChunk)chunk);
            }
            else if (chunk is SectionChunk)
            {
                Visit((SectionChunk)chunk);
            }
            else if (chunk is TemplateChunk)
            {
                Visit((TemplateChunk)chunk);
            }
            else if (chunk is RazorDirectiveChunk)
            {
                Visit((RazorDirectiveChunk)chunk);
            }
            else if (chunk is RazorDirectiveTokenChunk)
            {
                Visit((RazorDirectiveTokenChunk)chunk);
            }
            else if (chunk is ParentChunk)
            {
                Visit((ParentChunk)chunk);
            }
        }

        protected virtual void Visit(RazorDirectiveChunk chunk)
        {
        }

        protected virtual void Visit(RazorDirectiveTokenChunk chunk)
        {
        }

        protected virtual void Visit(ModelChunk chunk)
        {
            // TODO: Should remove once a more generic directive chunk is created.
        }

        protected virtual void Visit(InjectChunk chunk)
        {
            // TODO: Should remove once a more generic directive chunk is created.
        }

        protected virtual void Visit(LiteralChunk chunk)
        {
        }
        protected virtual void Visit(ParentLiteralChunk chunk)
        {
        }
        protected virtual void Visit(ExpressionBlockChunk chunk)
        {
        }
        protected virtual void Visit(ExpressionChunk chunk)
        {
        }
        protected virtual void Visit(StatementChunk chunk)
        {
        }
        protected virtual void Visit(UsingChunk chunk)
        {
        }
        protected virtual void Visit(ParentChunk chunk)
        {
            Accept(chunk.Children);
        }
        protected virtual void Visit(DynamicCodeAttributeChunk chunk)
        {
        }
        protected virtual void Visit(TagHelperChunk chunk)
        {
        }
        protected virtual void Visit(TagHelperPrefixDirectiveChunk chunk)
        {
        }
        protected virtual void Visit(AddTagHelperChunk chunk)
        {
        }
        protected virtual void Visit(RemoveTagHelperChunk chunk)
        {
        }
        protected virtual void Visit(LiteralCodeAttributeChunk chunk)
        {
        }
        protected virtual void Visit(CodeAttributeChunk chunk)
        {
        }
        protected virtual void Visit(SectionChunk chunk)
        {
        }
        protected virtual void Visit(TypeMemberChunk chunk)
        {
        }
        protected virtual void Visit(SetBaseTypeChunk chunk)
        {
        }
        protected virtual void Visit(TemplateChunk chunk)
        {
        }
    }
}