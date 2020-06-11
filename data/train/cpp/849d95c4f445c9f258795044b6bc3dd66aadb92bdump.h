/*
 * CHEST, chess analyst.  For Copyright notice read file "COPYRIGHT".
 *
 * $Source: /home/heiner/ca/chest/RCS/dump.h,v $
 * $Id: dump.h,v 3.4 1999/07/20 21:01:24 heiner Exp $
 *
 *	dump various data structures to standard output
 */

#ifndef CHEST_dump_h_INCLUDED
#define CHEST_dump_h_INCLUDED

#include "types.h"
#include "board.h"


Extern void	dump_pset        (PieceSet);
Extern void	dump_Pset        (PieceSet);
Extern void	dump_fieldset    (const FieldSet*);
Extern void	dump_packedboard (const PackedBoard*);
Extern void	dump_board       (const Board*);

#endif	/* ndef CHEST_dump_h_INCLUDED */
