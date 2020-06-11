
#pragma once

HRESULT InvokeSetProperty( IDispatch* disp, DISPID id, VARIANT& val );
HRESULT InvokeGetProperty( IDispatch* disp, DISPID id, VARIANT& val );

HRESULT InvokeSetProperty( IDispatch* disp, LPCWSTR nm, VARIANT& val );
HRESULT InvokeGetProperty( IDispatch* disp, LPCWSTR nm, VARIANT& val );


HRESULT InvokeMethod0( IDispatch* disp, DISPID id, VARIANT& ret );
HRESULT InvokeMethod1( IDispatch* disp, DISPID id, VARIANT& ret, VARIANT& pm1 );
HRESULT InvokeMethod2( IDispatch* disp, DISPID id, VARIANT& ret, VARIANT& pm1,VARIANT& pm2 );
HRESULT InvokeMethod3( IDispatch* disp, DISPID id, VARIANT& ret, VARIANT& pm1,VARIANT& pm2,VARIANT& pm3 );
HRESULT InvokeMethod4( IDispatch* disp, DISPID id, VARIANT& ret, VARIANT& pm1,VARIANT& pm2,VARIANT& pm3,VARIANT& pm4 );


HRESULT InvokeGetDISPID( IDispatch* disp, LPCWSTR nm, DISPID& id );



HRESULT InvokeMethod0( IDispatch* disp, LPCWSTR nm, VARIANT& ret );
HRESULT InvokeMethod1( IDispatch* disp, LPCWSTR nm, VARIANT& ret, VARIANT& pm1 );
HRESULT InvokeMethod2( IDispatch* disp, LPCWSTR nm, VARIANT& ret, VARIANT& pm1,VARIANT& pm2 );
HRESULT InvokeMethod3( IDispatch* disp, LPCWSTR nm, VARIANT& ret, VARIANT& pm1,VARIANT& pm2,VARIANT& pm3 );
HRESULT InvokeMethod4( IDispatch* disp, LPCWSTR nm, VARIANT& ret, VARIANT& pm1,VARIANT& pm2,VARIANT& pm3,VARIANT& pm4 );


class CDispatchHelper
{
	public :
		CDispatchHelper( IDispatch* p ):p_(p){}
		CDispatchHelper( VARIANT& v )
		{
			_ASSERT( v.vt == VT_DISPATCH );
			p_ = v.pdispVal;
		}
		
		HRESULT Method0( DISPID id, VARIANT& ret ){ return InvokeMethod0( p_, id, ret ); }
		HRESULT Method1( DISPID id, VARIANT& ret, VARIANT& pm1 ){ return InvokeMethod1( p_, id, ret,pm1); }
		HRESULT Method2( DISPID id, VARIANT& ret, VARIANT& pm1,VARIANT& pm2 ){ return InvokeMethod2( p_, id, ret,pm1,pm2 ); }
		HRESULT Method3( DISPID id, VARIANT& ret, VARIANT& pm1,VARIANT& pm2,VARIANT& pm3 ){ return InvokeMethod3( p_, id, ret,pm1,pm2,pm3 ); }
		HRESULT Method4( DISPID id, VARIANT& ret, VARIANT& pm1,VARIANT& pm2,VARIANT& pm3,VARIANT& pm4 ){ return InvokeMethod4( p_, id, ret,pm1,pm2,pm3,pm4 ); }

		HRESULT Method0( LPCWSTR nm, VARIANT& ret ){ return InvokeMethod0( p_, nm, ret); }
		HRESULT Method1( LPCWSTR nm, VARIANT& ret, VARIANT& pm1 ){ return InvokeMethod1( p_, nm, ret,pm1 ); }
		HRESULT Method2( LPCWSTR nm, VARIANT& ret, VARIANT& pm1,VARIANT& pm2 ){ return InvokeMethod2( p_, nm, ret,pm1,pm2 ); }
		HRESULT Method3( LPCWSTR nm, VARIANT& ret, VARIANT& pm1,VARIANT& pm2,VARIANT& pm3 ){ return InvokeMethod3( p_, nm, ret,pm1,pm2,pm3 ); }
		HRESULT Method4( LPCWSTR nm, VARIANT& ret, VARIANT& pm1,VARIANT& pm2,VARIANT& pm3,VARIANT& pm4 ){ return InvokeMethod4( p_, nm, ret,pm1,pm2,pm3,pm4 ); }


		HRESULT SetProperty( DISPID id, VARIANT& val ){ return InvokeSetProperty( p_, id,val ); }
		HRESULT GetProperty( DISPID id, VARIANT& val ){ return InvokeGetProperty( p_, id,val ); }

		HRESULT SetProperty( LPCWSTR nm, VARIANT& val ){ return InvokeSetProperty( p_, nm,val ); }
		HRESULT GetProperty( LPCWSTR nm, VARIANT& val ){ return InvokeGetProperty( p_, nm,val ); }


		HRESULT GetDISPID( LPCWSTR nm, DISPID& id ){ return InvokeGetDISPID( p_, nm, id ); }

	private :
		IDispatch* p_;

};
