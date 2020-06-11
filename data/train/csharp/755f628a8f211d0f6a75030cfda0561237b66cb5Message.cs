using System;

public struct Message
{
    public Message(InstrumentType instrument, Note note, byte velocity)
    {
        Instrument = instrument;
        Note = note;
        Velocity = velocity;
    }

    public InstrumentType Instrument;
    public Note Note;
    public byte Velocity;

    public string ToString()
    {
        return string.Format("{0}|{1}|{2}", (byte)Instrument, (byte)Note, Velocity);
    }

    public static Message FromString(string message)
    {
        string[] values = message.Split(new char[] { '|' }, StringSplitOptions.RemoveEmptyEntries);
        return new Message((InstrumentType)byte.Parse(values[0]), (Note)byte.Parse(values[1]), (byte)byte.Parse(values[2]));
    }
}
