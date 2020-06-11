/// @date 06/03/2013
#ifndef LOAD_INT_HH
# define LOAD_INT_HH

# include <bytecode/visitor.hh>
# include <bytecode/bytecode.hh>

namespace bytecode
{
    class LoadInt : public Bytecode
    {
        public:
            LoadInt(const yy::location& location,
                    int value);
            virtual ~LoadInt();

            int value_get() const;

            virtual void accept(Visitor& visitor) const;

        protected:
            int value_;
    };
} // namespace bytecode

# include <bytecode/load-int.hxx>

#endif /* !LOAD_INT_HH */
