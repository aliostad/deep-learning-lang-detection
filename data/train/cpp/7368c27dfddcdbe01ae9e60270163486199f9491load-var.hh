/// @date 05/03/2013
#ifndef LOAD_VAR_HH
# define LOAD_VAR_HH

# include <bytecode/visitor.hh>
# include <bytecode/bytecode.hh>

namespace bytecode
{
    class LoadVar : public Bytecode
    {
        public:
            LoadVar(const yy::location& location,
                    unsigned addr);
            virtual ~LoadVar();

            unsigned addr_get() const;

            void accept(Visitor& visitor) const;

        protected:
            unsigned addr_;
    };
} // namespace bytecode

# include <bytecode/load-var.hxx>

#endif /* !LOAD_VAR_HH */
