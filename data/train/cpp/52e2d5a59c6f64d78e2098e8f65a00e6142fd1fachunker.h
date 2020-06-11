#pragma once

#include <filearchive.h>
#include <noncopyable.h>

#include <list>
#include <memory>
#include <sstream>
#include <string>

template <typename T>
class Chunker : Noncopyable {
public:
    typedef T EntryType;

    Chunker(const std::string& chnkDir, size_t countInChnk,
        std::function<void(const char*)> chnkFilled = std::function<void(const char*)>()) :
            chunkDir(chnkDir),
            countInChunk(countInChnk),
            chunkDataCounter(0),
            chunkCounter(0),
            chunkFilled(chnkFilled) {
        std::string chunkFileName = getChunkFileName();
        chunkFileNames.push_back(chunkFileName);
        fileArchive.reset(new FileOutArchive(chunkFileName));
    }

    void add(const EntryType& entry) {
        if (chunkDataCounter == countInChunk) {
            ++chunkCounter;

            std::string prevChunkFileName = chunkFileNames.back();

            std::string chunkFileName = getChunkFileName();
            chunkFileNames.push_back(chunkFileName);
            fileArchive.reset(new FileOutArchive(chunkFileName));
            chunkDataCounter = 0;

            if (chunkFilled) {
                chunkFilled(prevChunkFileName.c_str());
            }
        }

        serialize(entry, *fileArchive.get());
        ++chunkDataCounter;
    }

    const std::list<std::string> getChunkFileNames() const {
        return chunkFileNames;
    }

    void flush() {
        fileArchive->flush();
    }

private:
    std::string getChunkFileName() const {
        std::stringstream sstr;
        sstr << chunkDir << "/chunk_" << chunkCounter << ".dat";
        return sstr.str();
    }

private:
    const std::string chunkDir;
    const size_t countInChunk;
    size_t chunkDataCounter;
    size_t chunkCounter;
    std::list<std::string> chunkFileNames;
    std::shared_ptr<FileOutArchive> fileArchive;
    std::function<void(const char*)> chunkFilled;
};
