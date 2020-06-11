/// @date 19/03/2013
#ifndef LOAD_LOCAL_HH
# define LOAD_LOCAL_HH

# include <bytecode/visitor.hh>
# include <bytecode/bytecode.hh>

namespace bytecode
{
    class LoadLocal : public Bytecode
    {
        public:
            LoadLocal(const yy::location& location,
                      unsigned addr);
            virtual ~LoadLocal();

            unsigned addr_get() const;

            void accept(Visitor& visitor) const;

        protected:
            unsigned addr_;
    };
} // namespace bytecode

# include <bytecode/load-local.hxx>

#endif /* !LOAD_LOCAL_HH */
