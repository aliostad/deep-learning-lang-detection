#include "../../../include/odfaeg/Sound/player.h"
using namespace sf;
namespace odfaeg {
    namespace sound {
        Player::Player(SoundBuffer& buffer) {
             Stream* stream = new Stream();
             stream->load(buffer);
             this->stream = stream;
        }
        void Player::setAudioStream(SoundStream* stream) {
             this->stream = stream;
        }
        sf::SoundStream* Player::getAudioStream() {
            return stream;
        }
        void Player::play() {
             stream->play();
        }
        void Player::stop() {
             stream->stop();
        }
        void Player::pause() {
             stream->pause();
        }
        Player::~Player() {
            delete stream;
        }
    }
}

