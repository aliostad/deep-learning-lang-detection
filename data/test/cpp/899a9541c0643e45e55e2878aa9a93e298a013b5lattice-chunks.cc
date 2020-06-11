#include "swan/wf_interface.h"

#define QSIZE 16
#define CHUNK 256
typedef float chunk_t[CHUNK];

void generate( obj::pushdep<chunk_t> out, int n ) {
    for( int i=0; i < n; i += CHUNK ) {
	static chunk_t c;
	for( int j=0; j < CHUNK; ++j ) {
	    c[j] = i+j+1;
	}
	out.push( c );
    }
}

void delay( obj::popdep<chunk_t> in, obj::pushdep<chunk_t> out, int n ) {
    float prev = 0;
    while( !in.empty() ) {
	const chunk_t & ci = in.pop();
	for( int c=0; c < 2; ++c ) {
	    static chunk_t co;
	    for( int j=0; j < CHUNK; j += 2 ) {
		float f = ci[c*CHUNK/2+j/2];
		co[j] = f;
		co[j+1] = prev;
		prev = f;
	    }
	    out.push( co );
	}
    }
}

void filter( obj::popdep<chunk_t> in, obj::pushdep<chunk_t> out, float k, int n ) {
    while( !in.empty() ) {
	const chunk_t & ci = in.pop();
	static chunk_t co;
	for( int i=0; i < CHUNK; i += 2 ) {
	    float f0 = ci[i];
	    float f1 = ci[i+1];
	    float ei = f0 - k * f1;
	    float ebari = f1 - k * f0;
	    co[i] = ei;
	    co[i+1] = ebari;
	}
	out.push( co );
    }
}

void pf( const chunk_t ci ) {
    for( int i=0; i < CHUNK; i++ ) {
	printf( "%f\n", ci[i] );
    }
}

void final( obj::popdep<chunk_t> in, int n ) {
    while( !in.empty() ) {
	const chunk_t & ci = in.pop();
	leaf_call( pf, ci );
    }
}

void work( int n ) {
    obj::hyperqueue<chunk_t> * q1[11];
    obj::hyperqueue<chunk_t> * q2[11];

    for( int i=1; i <= 10; ++i ) {
	q1[i] = new obj::hyperqueue<chunk_t>( QSIZE, 0 );
	q2[i] = new obj::hyperqueue<chunk_t>( QSIZE, 0 );
    }

    spawn( generate, (obj::pushdep<chunk_t>)*q1[2], n );
    for( int i=2; i < 10; ++i ) {
	spawn( delay, (obj::popdep<chunk_t>)*q1[i],
	       (obj::pushdep<chunk_t>)*q2[i], n );
	spawn( filter, (obj::popdep<chunk_t>)*q2[i],
	       (obj::pushdep<chunk_t>)*q1[i+1], (float)2, n );
    }
    spawn( final, (obj::popdep<chunk_t>)*q1[10], n );

    ssync();
}

int main( int argc, char * argv[] ) {
    int n = 10;
    if( argc > 1 )
	n = atoi( argv[1] );

    run( work, n );

    return 0;
}

