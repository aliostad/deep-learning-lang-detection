using System.Collections.Generic;
using Ductia.Domain;

namespace Ductia.Persistence
{
	public interface IPieceRepository
	{
		IEnumerable<Grade> SearchPieces(Instrument instrument, byte grade);
		IEnumerable<Book> SearchBooks(Instrument instrument, IEnumerable<byte> grades);
		IEnumerable<Book> SearchBooks(string examBoard, Instrument instrument, IEnumerable<byte> grades);
		IEnumerable<Grade> SearchPieces(Instrument instrument);
		IEnumerable<Grade> SearchPieces(Instrument instrument, IEnumerable<byte> grades);

	}
}