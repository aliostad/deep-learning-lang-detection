#ifndef _FNORD_CHUNK_ASSEMBLER
#define _FNORD_CHUNK_ASSEMBLER

#include <functional>

namespace fnord {

    template<typename buffer_type, typename chunk_id, chunk_id INITIAL_CHUNK_ID, size_t MAX_CHUNK_LENGTH>
    class chunk_assembler {
    public:
        using chunk_info = struct {
            chunk_id id;
            size_t length;
        };
        using cursor_type = class buffer_type::cursor;
        using callback_type = void(chunk_id, const buffer_type, chunk_info &);

    private:
        uint8_t scratch_data[MAX_CHUNK_LENGTH];
        cursor_type scratch;
        chunk_info current;

    public:
        constexpr chunk_assembler() noexcept :
                scratch(buffer_type(scratch_data, MAX_CHUNK_LENGTH).begin()),
                current{INITIAL_CHUNK_ID, 0}
        {}


        void assemble(const buffer_type buffer, function<callback_type> chunk_handler) {
            cursor_type c = buffer.begin();

            if (scratch.position()) {
                size_t missing = current.length - scratch.position();
                if (c.remaining() < missing) {
                    scratch.put(c);
                    return;
                }

                scratch.put(c.consume(missing));
                chunk_handler(current.id, scratch.flip(), current);
                scratch.reset();
            }

            while (c.remaining() >= current.length) {
                chunk_handler(current.id, c.consume(current.length), current);
            }

            scratch.put(c);
        }
    };
}

#endif