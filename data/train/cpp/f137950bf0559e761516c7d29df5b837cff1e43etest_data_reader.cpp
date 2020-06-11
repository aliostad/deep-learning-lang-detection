#include <stdio.h>
#include "data_reader.hpp"
#include "header.hpp"

#include <boost/iostreams/filtering_stream.hpp>
#include <boost/iostreams/filter/gzip.hpp>
#include <boost/iostreams/device/file.hpp>

namespace io = boost::iostreams;

// int main()
// {
//     DataReader<std::string> reader(std::cin);
//     reader.start();
    
//     while (not reader.isEnd()) {
//         boost::shared_ptr<std::string> ptr = reader.read();
//         if (ptr.get() == NULL) {
//             ::printf("\n");
//         } else {
//             ::printf("%s\n", ptr->c_str());
//         }
//     }
//     reader.end();
//     return 0;
// }

/**
 * Specify full dump file name to argv[1],
 *         corresponding digest file name to argv[2].
 * This program check dump with digest.
 */
int main(int argc, char *argv[])
{
    io::filtering_istream is1;
    is1.push(io::gzip_decompressor());
    is1.push(io::file_source(argv[1]));

    io::filtering_istream is2;
    is2.push(io::gzip_decompressor());
    is2.push(io::file_source(argv[2]));

    /* dumpH */
    VmdkDumpHeader dumpH;
    is1 >> dumpH;
    dumpH.print();

    typedef Generator1<VmdkDumpBlock, size_t> DumpBGen;
    typedef boost::shared_ptr<DumpBGen> DumpBGenP;
    DumpBGenP dumpBGenP = DumpBGenP(new DumpBGen(dumpH.getBlockSize()));
    DataReader<VmdkDumpBlock> dumpReader(is1, dumpBGenP);
    dumpReader.start();

    /* digestH */
    VmdkDigestHeader digestH;
    is2 >> digestH;
    digestH.print();

    typedef Generator0<VmdkDigestBlock> DigestBGen;
    typedef boost::shared_ptr<DigestBGen> DigestBGenP;
    DigestBGenP digestBGenP = DigestBGenP(new DigestBGen);
    DataReader<VmdkDigestBlock> digestReader(is2, digestBGenP);
    digestReader.start();

    VmdkDigestBlock checkB;
    while (not digestReader.isEnd()) {
        boost::shared_ptr<VmdkDigestBlock> digestBP = digestReader.get();
        //digestBP->print();
        boost::shared_ptr<VmdkDumpBlock> dumpBP = dumpReader.get();
        //dumpBP->print();

        size_t oft = dumpBP->getOffset();
        if (oft % 64 == 0) {
            ::printf("%zu", oft);
        }
        checkB.set(*dumpBP);
        if (checkB == *digestBP) {
            ::printf(".");
            ::fflush(stdout);
        } else {
            ::printf("X");
            ::fflush(stdout);
        }
        if (dumpBP->getOffset() % 64 == 63) {
            ::printf("\n");

            digestReader.pause();
            dumpReader.pause();
            ::sleep(1);
            digestReader.resume();
            dumpReader.resume();
        }
    }
    assert (dumpReader.isEnd());

    dumpReader.stop();
    digestReader.stop();
    
    return 0;
}
