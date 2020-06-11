#include "BinaryStreamOutput.hpp"
#include "BinarySerializer.hpp"

namespace HintEditor {
    BinaryStreamOutput::BinaryStreamOutput(std::ostream &stream)
        : stream(stream) {
    }

    void BinaryStreamOutput::visit(HintForward &hint) {
        BinarySerializer::serialize(stream, hint);
    }

    void BinaryStreamOutput::visit(HintTurn &hint) {
        BinarySerializer::serialize(stream, hint);
    }

    void BinaryStreamOutput::visit(HintRoundabout &hint) {
        BinarySerializer::serialize(stream, hint);
    }
}