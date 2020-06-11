/// @date 06/03/2013
#ifndef LOAD_STR_HH
# define LOAD_STR_HH

# include <string>

# include <bytecode/visitor.hh>
# include <bytecode/bytecode.hh>

namespace bytecode
{
    class LoadStr : public Bytecode
    {
        public:
            LoadStr(const yy::location& location,
                    int data);
            virtual ~LoadStr();

            int data_get() const;

            void accept(Visitor& visitor) const;

        protected:
            int data_;
    };
} // namespace bytecode

# include <bytecode/load-str.hxx>

#endif /* !LOAD_STR_HH */
