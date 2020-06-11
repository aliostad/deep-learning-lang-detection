#include <slib/Tokenizer.h>

namespace slib {

	////////////////////////////////////////
	// TokenizerError
	////////////////////////////////////////

	TokenizerError::TokenizerError( const std::string & error ) : error_( error ) {
	}

	std::string TokenizerError::GetError( ) {
		return error_;
	}

	////////////////////////////////////////
	// functions
	////////////////////////////////////////

	// reads the stream until a non-digit is found
	std::string GetNumber( std::istream & stream ) {
		std::string number;
		if( stream.peek( ) >= '0' && stream.peek( ) <= '9' || stream.peek( ) == '-' || stream.peek( ) == '+' ) {
			number += stream.get( );
			for( ; stream.peek( ) >= '0' && stream.peek( ) <= '9' || stream.peek( ) == '.'; number += stream.get( ) );
		}
		return number;
	}

	// reads the stream until a non-digit is found
	std::string GetIdentifier( std::istream & stream ) {
		std::string ident;
		if( stream.peek( ) >= 'A' && stream.peek( ) <= 'Z' || stream.peek( ) >= 'a' && stream.peek( ) <= 'z' || stream.peek( ) == '_' ) {
			ident += stream.get( );
			for( ; stream.peek( ) >= 'A' && stream.peek( ) <= 'Z' || stream.peek( ) >= 'a' && stream.peek( ) <= 'z' || stream.peek( ) >= '0' && stream.peek( ) <= '9' || stream.peek( ) == '_'; ident += stream.get( ) );
		}
		return ident;
	}

	std::string GetStringConst( std::istream & stream ) {
		std::string str( 1, stream.get( ) );
		while( stream.peek( ) >= ' ' && stream.peek( ) <= '~' && stream.peek( ) != '"' ) {
			if( stream.peek( ) == '\\' ) {
				stream.get( );
				if( stream.peek( ) == 'n' ) {
					stream.get( );
					str += '\n';
				} else if( stream.peek( ) == 't' ) {
					stream.get( );
					str += '\t';
				} else if( stream.peek( ) == '0' ) {
					stream.get( );
					str += '\0';
				} else if( stream.peek( ) == '"' ) {
					stream.get( );
					str += '"';
				} else if( stream.peek( ) == '\\' ) {
					stream.get( );
					str += '\\';
				} else {
					stream.get( );
				}
			} else {
				str += stream.get( );
			}
		}
		str += stream.get( );
		return str;
	}

	std::string GetComment( std::istream & stream ) {
		std::string str;
		for( ; stream.peek( ) != '\n'; str += stream.get( ) );
		return str;
	}

	// reads the stream for the next token
	std::string GetToken( std::istream & stream ) {
		// ignore whitespace
		for( ; stream.peek( ) == 9 || stream.peek( ) == 10 || stream.peek( ) == 13 || stream.peek( ) == 32; stream.get( ) );

		int c = stream.peek( );
		if( c == -1 ) {
			// return blank token indicating end of stream
			return std::string( );
		} else if( c == '(' || c == ')' || c == ',' || c == ';' || c == '{' || c == '}' || c == '=' ) {
			// single character tokens
			return std::string( 1, (char)stream.get( ) );
		} else if( c >= '0' && c <= '9' || c == '-' || c == '+' ) {
			return GetNumber( stream );
		} else if( c >= 'A' && c <= 'Z' || c >= 'a' && c <= 'z' || c == '_' ) {
			return GetIdentifier( stream );
		} else if( c == '"' ) {
			return GetStringConst( stream );
		} else if( c == '#' ) {
			return GetComment( stream );
		} else {
			throw TokenizerError( "unknown start of token: " + std::string( 1, (char)c ) );
		}
	}

}
