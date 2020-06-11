/// @date 06/03/2013
#ifndef LOAD_FLOAT_HH
# define LOAD_FLOAT_HH

# include <bytecode/visitor.hh>
# include <bytecode/bytecode.hh>

namespace bytecode
{
    class LoadFloat : public Bytecode
    {
        public:
            LoadFloat(const yy::location& location,
                      float value);
            virtual ~LoadFloat();

            float value_get() const;

            virtual void accept(Visitor& visitor) const;

        protected:
            float value_;
    };
} //namespace bytecode

# include <bytecode/load-float.hxx>

#endif /* !LOAD_FLOAT_HH */
