#pragma once
#include "Types.h"
#include <vector>

namespace WinToolsLib
{
	class ChunkBase
	{
	public:
		ChunkBase(SizeT begin, SizeT end);
		ChunkBase(const ChunkBase& other);
		virtual ~ChunkBase() {}

		virtual SizeT GetBegin() const;
		virtual SizeT GetEnd() const;

		virtual Void SetBegin(SizeT begin);
		virtual Void SetEnd(SizeT end);

		virtual Bool IsSameType(const ChunkBase& other) const;
		virtual Bool operator<(const ChunkBase& other) const;

	protected:
		SizeT m_begin;
		SizeT m_end;
	};

	template <class ChunkType>
	class ChunkCollection
	{
	public:
		Void AddChunk(ChunkType&& chunk);
		Void Clear();
		Void Sort();
		Void Glue();
		Void Absorb();
		Void Normalize();

		Void operator-=(const ChunkCollection& other);
		
		const ChunkType& operator[](SizeT index) const;
		const ChunkType& GetChunk(SizeT index) const;

		SizeT GetCount() const;

	private:
		std::vector<ChunkType> m_chunks;
	};

	//
	// Add new chunk to the collection
	//
	template <class ChunkType>
	Void ChunkCollection<ChunkType>::AddChunk(ChunkType&& myChunk)
	{
		m_chunks.push_back(std::move(myChunk));
	}

	//
	// Remove all chunks
	//
	template <class ChunkType>
	Void ChunkCollection<ChunkType>::Clear()
	{
		m_chunks.clear();
	}

	//
	// Sort chunks by begin
	//
	template <class ChunkType>
	Void ChunkCollection<ChunkType>::Sort()
	{
		std::sort(
			begin(m_chunks),
			end(m_chunks),
			[](const ChunkType& chunk1, const ChunkType& chunk2)
			{
				return chunk1 < chunk2;
			});
	}

	//
	// Glue neighbor chunks together
	//
	template <class ChunkType>
	Void ChunkCollection<ChunkType>::Glue()
	{
		for (SizeT i = 0; i < m_chunks.size(); i++)
		{
			auto& currentChunk = m_chunks[i];
			
			for (SizeT j = i + 1; j < m_chunks.size(); j++)
			{
				const auto& otherChunk = m_chunks[j];
				
				if (currentChunk.GetEnd() == otherChunk.GetBegin() &&
					currentChunk.IsSameType(otherChunk))
				{
					currentChunk.SetEnd(otherChunk.GetEnd());
					m_chunks.erase(m_chunks.begin() + j--);
					continue;
				}
			}
		}
	}

	//
	// Absorb equal or smaller chunks
	//
	template <class ChunkType>
	Void ChunkCollection<ChunkType>::Absorb()
	{
		for (SizeT i = 0; i < m_chunks.size(); i++)
		{
			auto& currentChunk = m_chunks[i];
			
			for (SizeT j = i + 1; j < m_chunks.size(); j++)
			{
				const auto& otherChunk = m_chunks[j];
				
				if (currentChunk.GetBegin() <= otherChunk.GetBegin() &&
					currentChunk.GetEnd() >= otherChunk.GetEnd())
				{
					m_chunks.erase(m_chunks.begin() + j--);
					continue;
				}
			}
		}
	}

	//
	// Equals calling Sort() then Glue() and then Absorb()
	//
	template <class ChunkType>
	Void ChunkCollection<ChunkType>::Normalize()
	{
		Sort();
		Glue();
		Absorb();
	}

	//
	// Subtract one collection from the other
	//
	template <class ChunkType>
	Void ChunkCollection<ChunkType>::operator-=(const ChunkCollection<ChunkType>& other)
	{
		for (SizeT i = 0; i < m_chunks.size(); i++)
		{
			auto& myChunk = m_chunks[i];
			
			for (SizeT j = 0; j < other.m_chunks.size(); j++)
			{
				const auto& otherChunk = other.m_chunks[j];

				if (otherChunk.GetBegin() <= myChunk.GetBegin() &&
					otherChunk.GetEnd() > myChunk.GetBegin())
				{
					if (otherChunk.GetEnd() >= myChunk.GetEnd())
					{
						m_chunks.erase(m_chunks.begin() + i--);
						break;
					}
					else
					{
						myChunk.SetBegin(otherChunk.GetEnd());
						continue;
					}
				}

				if (otherChunk.GetBegin() < myChunk.GetEnd() &&
					otherChunk.GetEnd() >= myChunk.GetEnd())
				{
					myChunk.SetEnd(otherChunk.GetBegin());
					continue;
				}

				if (otherChunk.GetBegin() > myChunk.GetBegin() &&
					otherChunk.GetEnd() < myChunk.GetEnd())
				{
					auto copyChunk(myChunk);
					myChunk.SetEnd(otherChunk.GetBegin());

					copyChunk.SetBegin(otherChunk.GetEnd());
					m_chunks.insert(
						m_chunks.begin() + i-- + 1,
						copyChunk);
					break;
				}
			}
		}
	}

	//
	// Get chunk by its index
	//
	template <class ChunkType>
	const ChunkType& ChunkCollection<ChunkType>::operator[](SizeT index) const
	{
		return m_chunks[index];
	}

	//
	// Get chunk by its index
	//
	template <class ChunkType>
	const ChunkType& ChunkCollection<ChunkType>::GetChunk(SizeT index) const
	{
		return m_chunks.at(index);
	}

	//
	// Get collection size
	//
	template <class ChunkType>
	SizeT ChunkCollection<ChunkType>::GetCount() const
	{
		return m_chunks.size();
	}
}
