/////////////////////////////////////////////////////////////////////////////
//
// (c) 2007 BinaryComponents Ltd.  All Rights Reserved.
//
// http://www.binarycomponents.com/
//
/////////////////////////////////////////////////////////////////////////////

using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace BinaryComponents.WinFormsUtility.Commands
{
	public abstract class Command
	{
		#region Hooks

		public abstract class PreInvokeHook
		{
			protected PreInvokeHook()
			{
			}

			public abstract bool Apply( Command command, IWin32Window owner );
		}

		public abstract class PostInvokeHook
		{
			protected PostInvokeHook()
			{
			}

			public abstract void Apply( Command command, IWin32Window owner, bool success );
		}

		#endregion

		public delegate void Invoker( Control onwer );

		protected Command()
		{
		}

		public bool Invoke( Control owner )
		{
			if( !IsEnabled() )
			{
				return false;
			}

			if( _preInvokeHooks != null )
			{
				foreach( PreInvokeHook hook in _preInvokeHooks )
				{
					if( !hook.Apply( this, owner ) )
					{
						return false;
					}
				}
			}

			OnPreInvoke( EventArgs.Empty );

			_stack.Push( this );

			bool success = PerformInvoke( owner );

			_stack.Pop();

			OnPostInvoke( EventArgs.Empty );

			if( _postInvokeHooks != null )
			{
				foreach( PostInvokeHook hook in _postInvokeHooks )
				{
					hook.Apply( this, owner, success );
				}
			}

			return success;
		}

		public void AddPreInvokeHook( PreInvokeHook hook )
		{
			if( hook == null )
			{
				throw new ArgumentNullException( "hook" );
			}
			if( _preInvokeHooks == null )
			{
				_preInvokeHooks = new List<PreInvokeHook>();
			}

			_preInvokeHooks.Add( hook );
		}

		public void AddPostInvokeHook( PostInvokeHook hook )
		{
			if( hook == null )
			{
				throw new ArgumentNullException( "hook" );
			}
			if( _postInvokeHooks == null )
			{
				_postInvokeHooks = new List<PostInvokeHook>();
			}

			_postInvokeHooks.Add( hook );
		}

		public virtual bool IsEnabled()
		{
			return true;
		}

		public virtual bool IsChecked()
		{
			return false;
		}
	
		public virtual string GetText( string originalText )
		{
			return null;
		}

		public override int GetHashCode()
		{
			return GetType().GetHashCode();
		}

		public override bool Equals( object obj )
		{
			Command cmd = obj as Command;

			if( cmd == null )
			{
				return false;
			}
			else
			{
				return object.Equals( GetType(), cmd.GetType() );
			}
		}

		public static Command[] ActiveCommands
		{
			get
			{
				return _stack.ToArray();
			}
		}

		protected abstract bool PerformInvoke( Control owner );

		public static event EventHandler PreInvoke;
		public static event EventHandler PostInvoke;

		private static void OnPreInvoke( EventArgs e )
		{
			if( PreInvoke != null )
			{
				PreInvoke( null, e );
			}
		}

		private static void OnPostInvoke( EventArgs e )
		{
			if( PostInvoke != null )
			{
				PostInvoke( null, e );
			}
		}

		private List<PreInvokeHook> _preInvokeHooks;
		private List<PostInvokeHook> _postInvokeHooks;

		private static Stack<Command> _stack = new Stack<Command>();
	}
}
