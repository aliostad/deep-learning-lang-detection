#ifndef __MIDILLO_CHUNK_H
#define __MIDILLO_CHUNK_H

#include <istream>
#include <ostream>

/**
 * @file
 * @brief Generic SMF chunk manipulation
 */

namespace midillo {
    using std::istream;
    using std::ostream;

    enum {
	chunk_id_MThd = 0x6468544d,
	chunk_id_MTrk = 0x6b72544d
    };
    /**
     * Chunk header data structure
     */
    struct chunk_header_t {
	/**
	 * Track signature data
	 */
	union {
	    /**
	     * ASCII representation
	     */
	    char id_chars[4];
	    /**
	     * long integer representation
	     */
	    unsigned long  id_number;
	};
	/**
	 * Chunk length
	 */
	unsigned long length;

	chunk_header_t()
	    : id_number(0), length(0) { }
	chunk_header_t(const chunk_header_t& s)
	    : id_number(s.id_number), length(s.length) { };

	chunk_header_t& operator=(const chunk_header_t& s) {
	    id_number=s.id_number; length=s.length;
	    return *this;
	}

	/**
	 * Load chunk header from the stream
	 * @param s input stream
	 */
	void load(istream& s);
	/**
	 * Save chunk header to the stream
	 * @param s output stream
	 */
	void save(ostream& s) const;

	/**
	 * Dump textual representation of chunk header to stream
	 * @param s output stream
	 */
	void dump(ostream& s) const;

    };

    inline ostream& operator<<(ostream& s,const chunk_header_t& ch) {
	ch.dump(s); return s;
    }

    /**
     * Base class for specific chunk containers
     */
    class chunk_t {
	public:
	    /**
	     * Chunk header data
	     */
	    chunk_header_t header;
    };

}

#endif /* __MIDILLO_CHUNK_H */
