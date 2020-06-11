#include "command.h"

void Epikon::Protocol::Command::sendToSocket(QTcpSocket* socket) const
{
    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_6);
    out << (quint16)0;
    this->writeToDataStream(out);
    out.device()->seek(0);
    quint16 sz = (quint16)(block.size() - sizeof(quint16));
    out << sz;
    quint64 written = socket->write(block);
    if (written!=block.size()){
        qWarning() << "Could not send command " << this << " size:" << block.size() << " sent:" << written << " buffer:" <<  block;
        return;
    }
    qDebug() << "Sending Command " << this << " type:" << m_type << " size:" << written << "buffer:" << block.toHex();
}

void Epikon::Protocol::Command::readFromDataStream(QDataStream& stream)
{
//    stream >> m_type;
    stream >> m_sendtime;
}

void Epikon::Protocol::Command::writeToDataStream(QDataStream& stream) const
{
    stream << m_type;
    stream << m_sendtime;
}

void Epikon::Protocol::Hello::readFromDataStream(QDataStream& stream)
{
    Command::readFromDataStream(stream);
    stream >> m_id;
}

void Epikon::Protocol::Hello::writeToDataStream(QDataStream& stream) const
{
    Command::writeToDataStream(stream);
    stream << m_id;
}

void Epikon::Protocol::Attack::readFromDataStream(QDataStream& stream)
{
    Command::readFromDataStream(stream);
    stream >>  m_fromplanet >> m_toplanet >> m_fromplayer >> m_toplayer >> m_numships >>  m_sendtime;
}

void Epikon::Protocol::Attack::writeToDataStream(QDataStream& stream) const
{
    Command::writeToDataStream(stream);
    stream <<  m_fromplanet << m_toplanet << m_fromplayer << m_toplayer << m_numships <<  m_sendtime;
}

QDataStream & operator<< (QDataStream& stream, const Epikon::Protocol::CommandType& cmd){
    quint16 out = cmd;
    stream << out;
    return stream;
}

QDataStream & operator>> (QDataStream& stream, enum Epikon::Protocol::CommandType& cmd){
    quint16 in;
    stream >> in;
    cmd = Epikon::Protocol::CommandType(in);
    return stream;
}

QDataStream & operator<< (QDataStream& stream, const Epikon::Protocol::Command& cmd){
    cmd.writeToDataStream(stream);
    return stream;
}

QDataStream & operator>> (QDataStream& stream, Epikon::Protocol::Command& cmd){
    cmd.readFromDataStream(stream);
    return stream;
}
