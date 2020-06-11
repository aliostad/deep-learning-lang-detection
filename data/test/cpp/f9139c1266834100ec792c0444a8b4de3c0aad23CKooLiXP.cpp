#include "Dynamo/classes/CInterfaceProvider.h"
#include "koolib/xml/XMLChunksProgram.h"
#include "koolib/xml/XMLChunksUseless.h"

namespace Dynamo {
    
    IPaint *CreateIPaint( const Useless::WidgetPainter & );

    struct CXmlChunk: IXmlChunk, CInterface
    {
        XMLProgram::IChunkPtr _pChunk;

        CXmlChunk( XMLProgram::IChunk *pChunk ): _pChunk( pChunk )
        {
        }

        ~CXmlChunk()
        {
        }

        bool GetAttr( const std::string &name, int *pInt )
        {
            TextAnsi wname( name );
            XMLFactory::Attr< int, false, wchar_t > attr( wname );
            if ( (*_pChunk) >> attr && 0 != pInt )
            {
                (*pInt) = *attr;
                return true;
            }
            else
            {
                return false;
            }
        }

        bool GetAttr( const std::string &name, double *pFloat )
        {
            TextAnsi wname( name );
            XMLFactory::Attr< double, false, wchar_t > attr( wname );
            if ( (*_pChunk) >> attr && 0 != pFloat )
            {
                (*pFloat) = *attr;
                return true;
            }
            else
            {
                return false;
            }
        }

        bool GetAttr( const std::string &name, std::basic_string< wchar_t > *pText )
        {
            TextAnsi wname( name );
            XMLFactory::Attr< TextUtf8, false, wchar_t > attr( wname );
            if ( (*_pChunk) >> attr && 0 != pText )
            {
                (*pText) = TextUtf8( attr.str() );
                return true;
            }
            else
            {
                return false;
            }
        }
        
        int AsInt()
        {
            return XMLProgram::value_of< int >( _pChunk.get() );
        }
        
        float AsFloat()
        {
            return XMLProgram::value_of< float >( _pChunk.get() );
        }
        
        IPaint * AsIPaint()
        {
            if ( XMLProgram::WidgetPainterProxy *proxy = dynamic_cast< XMLProgram::WidgetPainterProxy *>( _pChunk.get() ))
            {
                return CreateIPaint( proxy->_wpainter );
            }
            else
            {
                return NULL;
            }
        }
        
        std::basic_string< wchar_t > AsText()
        {
            return XMLProgram::value_of< TextUtf8 >( _pChunk.get() );
        }

        IXmlChunk* GetChunk( const std::string &name )
        {
            if ( XMLProgram::IChunk *pChunk = _pChunk->GetChunk( TextAnsi( name )))
            {
                return new CXmlChunk( pChunk );
            }
            else
            {
                return 0;
            }
        }
        
        IXmlChunk*  GetChunk( unsigned int code )
        {
            if ( XMLProgram::IChunk *pChunk = _pChunk->GetChunk( code ))
            {
                return new CXmlChunk( pChunk );
            }
            else
            {
                return 0;
            }
        }

        void SetChunk( const std::string &name, IXmlChunk *pChunk )
        {
            Hand< IXmlChunk > guard( pChunk );
            if ( CXmlChunk *pCChunk = dynamic_cast< CXmlChunk *>( pChunk ))
            {
                _pChunk->SetChunk( TextAnsi( name ), pCChunk->_pChunk.get() );
            }
        }

        void Execute( IXmlScope *pScope );
        
        bool IsEmpty()
        {
            return XMLProgram::IsEmpty( _pChunk.get() );
        }
    };

    struct CXmlScope : IXmlScope, CInterface
    {
        XMLProgram::ExecutionState _state;
        XMLProgram::IBlockPtr      _guardian;

        CXmlScope( XMLProgram::ExecutionState &state ): _state( state )
        {
        }

        ~CXmlScope()
        {
        }

        void SetResult( IXmlChunk *pChunk )
        {
            Hand< IXmlChunk > guard( pChunk );
            if ( CXmlChunk *pCChunk = dynamic_cast< CXmlChunk *>( pChunk ))
            {
                _state.SetResult( pCChunk->_pChunk.get() );
            }
        }
        
        IXmlChunk* GetChunk( const std::string &name )
        {
            XMLProgram::IChunk *pChunk = XMLProgram::GetChunk( TextAnsi( name ), _state );
            if ( 0 != pChunk )
            {
                return new CXmlChunk( pChunk );
            }
            else
            {
                return 0;
            }
        }

        void SetChunk( const std::string &name, IXmlChunk *pChunk )
        {
            Hand< IXmlChunk > guard( pChunk );
            if ( CXmlChunk *pCChunk = dynamic_cast< CXmlChunk *>( pChunk ))
            {
                XMLProgram::IChunk *pParent = 0;
                XMLProgram::IChunk *pChunk = XMLProgram::GetChunk( TextAnsi( name ), _state, &pParent );
                if ( 0 != pParent )
                {
                    pParent->SetChunk( TextAnsi( name ), pCChunk->_pChunk.get() );
                }
            }
        }

        void AddChunk( const std::string &name, IXmlChunk *pChunk )
        {
            Hand< IXmlChunk > guard( pChunk );
            if ( CXmlChunk *pCChunk = dynamic_cast< CXmlChunk *>( pChunk ))
            {
                _state._currentBlock->AddChunk( TextAnsi( name ), pCChunk->_pChunk.get() );
            }
        }
        
        void AddMethod( const std::string &name, IXmlHook *pHook );
        
        IXmlScope*  NewScope()
        {
            CXmlScope *pNewScope = new CXmlScope( _state );
            pNewScope->_guardian = pNewScope->_state._currentBlock = new XMLProgram::XMLCodeBlock;
            pNewScope->_state._prevState = &_state;
            return pNewScope;
        }
    };
    
    void CXmlChunk::Execute( IXmlScope *pScope )
    {
        Hand< IXmlScope > guard( pScope );
        if ( CXmlScope * pCScope = dynamic_cast< CXmlScope *>( pScope ))
        {
            _pChunk->Execute( XMLFactory::Node(), pCScope->_state );
        }
    }

    struct CXmlMethodHook : XMLProgram::IChunk
    {
        Hand< IXmlHook > _pHook;

        CXmlMethodHook( IXmlHook *pHook ): _pHook( pHook )
        {
        }

        ~CXmlMethodHook()
        {
            _pHook = 0;
        }

        bool Execute( XMLProgram::ExecutionState &state )
        {
            Hand< CXmlScope > pScope = new CXmlScope( state );
            _pHook->Apply( pScope.get() );
            return true;
        }

        bool Execute( XMLFactory::Node node, XMLProgram::ExecutionState &state )
        {
            Hand< CXmlScope > pScope = new CXmlScope( state );
            _pHook->Apply( pScope.get() );
			state.SetResult( pScope->_state.GetResult() );
            return true;
        }
    };
        
    void CXmlScope::AddMethod( const std::string &name, IXmlHook *pHook )
    {
        _state._currentBlock->AddChunk( TextAnsi( name ), new CXmlMethodHook( pHook ));
    }

    struct CXmlProgram : IXmlProgram, CInterface
    {
        XMLProgram::IFiniteStateMachine *_pFSM;

        CXmlProgram( XMLProgram::IFiniteStateMachine *pFSM ): _pFSM( pFSM )
        {
        }

        ~CXmlProgram()
        {
        }
        
        IXmlScope*  NewScope( XMLProgram::ExecutionState &state )
        {
            return new CXmlScope( state );
        }
        
        IXmlScope*  GetScope()
        {
            return new CXmlScope( _pFSM->GetCurrentExecutionState());
        }

        IXmlChunk*  NewInt( int value )
        {
            return new CXmlChunk( XMLProgram::make_value_chunk( value ));
        }

        IXmlChunk*  NewFloat( double value )
        {
            return new CXmlChunk( XMLProgram::make_value_chunk( value ));
        }

        IXmlChunk*  NewText( const std::basic_string< wchar_t > &value )
        {
            return new CXmlChunk( XMLProgram::make_value_chunk( value ));
        }

        IXmlChunk*  NewList()
        {
            return new CXmlChunk( new XMLProgram::XMLEmpty() );
        }

        IXmlChunk* Append( IXmlChunk *pListChunk, IXmlChunk *pChunk )
        {
            Hand< IXmlChunk > guard1( pListChunk );
            Hand< IXmlChunk > guard2( pChunk );
            if ( pChunk->IsEmpty() )
            {
                return pListChunk;
            }

            if ( CXmlChunk *pCChunk = dynamic_cast< CXmlChunk *>( pChunk ))
            {
                if ( CXmlChunk *pCListChunk = dynamic_cast< CXmlChunk *>( pListChunk ))
                {
                    if ( pCListChunk->IsEmpty() )
                    {
                        XMLProgram::XMLListChunk *pList = new XMLProgram::XMLListChunk( pCChunk->_pChunk.get(), pCListChunk->_pChunk.get() );
                        pCListChunk->_pChunk = pList;
                        return pCListChunk;
                    }
                    else
                    {
                        XMLProgram::XMLListChunk *pList0 = dynamic_cast< XMLProgram::XMLListChunk *>( pCListChunk->_pChunk.get() );

                        if ( XMLProgram::IsEmpty( pList0->_tail.get() ))
                        {
                            XMLProgram::XMLListChunk *pList = new XMLProgram::XMLListChunk( pCChunk->_pChunk.get(), new XMLProgram::XMLEmpty() );
                            pList0->SetTail( pList );
                            return new CXmlChunk( pList );
                        }
                        else
                        {
                            throw Useless::Error("CXmlProgram::Append() First argument must be empty or last node.");
                        }
                    }
                }
            }
            return pListChunk;
        }
    };

    IXmlProgram * CInterfaceProvider::ProvideIXmlProgram( XMLProgram::IFiniteStateMachine *pFSM )
    {
        return new CXmlProgram( pFSM );
    }

};//namespace Dynamo
