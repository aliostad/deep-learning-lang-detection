#include "multiscale/util/ConsolePrinter.hpp"

using namespace multiscale;

const std::string SAMPLE_TAG = "[ SAMPLE ]";
const std::string SAMPLE_MSG = "This is a sample message.";


// Main function
int main() {
    ConsolePrinter::printMessage(SAMPLE_MSG);
    ConsolePrinter::printMessageWithColouredTag(SAMPLE_MSG, SAMPLE_TAG, ColourCode::CYAN);
    ConsolePrinter::printColouredMessage(SAMPLE_MSG, ColourCode::MAGENTA);
    ConsolePrinter::printColouredMessageWithColouredTag(SAMPLE_MSG, ColourCode::BLUE,
                                                        SAMPLE_TAG, ColourCode::RED);
}
