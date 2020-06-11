/*
 * Copyright 2009  Gregory Haynes <greg@greghaynes.net>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "textchunk.h"

namespace QInfinity
{

TextChunk::TextChunk( InfTextChunk *infChunk,
    bool own_chunk )
    : m_infChunk( infChunk )
    , m_own_chunk( own_chunk )
{
}

TextChunk::TextChunk( const QString &encoding )
    : m_infChunk( inf_text_chunk_new( encoding.toAscii() ) )
    , m_own_chunk( true )
{
}

TextChunk::TextChunk( const TextChunk &other )
{
    m_infChunk = inf_text_chunk_copy( other.infChunk() );
    m_own_chunk = true;
}

TextChunk::~TextChunk()
{
    if( m_own_chunk )
        inf_text_chunk_free( m_infChunk );
}

QString TextChunk::encoding() const
{
    return inf_text_chunk_get_encoding( infChunk() );
}

unsigned int TextChunk::length() const
{
    return inf_text_chunk_get_length( infChunk() );
}

QByteArray TextChunk::text() const
{
    void *data;
    gsize size;
    data = inf_text_chunk_get_text( infChunk(), &size );
    return QByteArray( (const char*)data, size );
}

void TextChunk::insertText( unsigned int offset,
    const QByteArray &data,
    unsigned int length,
    unsigned int author )
{
    inf_text_chunk_insert_text( m_infChunk,
        offset, data.data(),
        data.size(), length,
        author );
}

void TextChunk::insertChunk( unsigned int offset,
    const TextChunk &chunk )
{
    inf_text_chunk_insert_chunk( infChunk(), offset,
        chunk.infChunk() );
}

void TextChunk::erase( unsigned int begin,
    unsigned int end )
{
    inf_text_chunk_erase( infChunk(),
        begin, end );
}

InfTextChunk *TextChunk::infChunk() const
{
    return m_infChunk;
}

}

