using Mine.NET.block;

namespace Mine.NET.Event.block
{
    /**
     * Called when a note block is being played through player interaction or a
     * redstone current.
     */
    public class NotePlayEventArgs : BlockEventArgs, Cancellable
    {
        private Instrument instrument;
        private Note note;
        private bool cancelled = false;

        public NotePlayEventArgs(Block block, Instrument instrument, Note note) : base(block)
        {
            this.instrument = instrument;
            this.note = note;
        }

        public bool isCancelled()
        {
            return cancelled;
        }

        public void setCancelled(bool cancel)
        {
            this.cancelled = cancel;
        }

        /**
         * Gets the {@link Instrument} to be used.
         *
         * @return the Instrument;
         */
        public Instrument getInstrument()
        {
            return instrument;
        }

        /**
         * Gets the {@link Note} to be played.
         *
         * @return the Note.
         */
        public Note getNote()
        {
            return note;
        }

        /**
         * Overrides the {@link Instrument} to be used.
         *
         * @param instrument the Instrument. Has no effect if null.
         */
        public void setInstrument(Instrument instrument)
        {
            this.instrument = instrument;
        }

        /**
         * Overrides the {@link Note} to be played.
         *
         * @param note the Note. Has no effect if null.
         */
        public void setNote(Note note)
        {
            if (note != null)
            {
                this.note = note;
            }
        }
    }
}
