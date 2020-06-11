#pragma once

namespace streams
{
   template < class Stream, class S, size_t D >
   void write( Stream & stream, cg::point_t<S, D> const & point )
   {
      stream.write( &point, sizeof(point) );
   }

   template < class Stream, class S, size_t D >
   void read( Stream & stream, cg::point_t<S, D> & point )
   {
      stream.read( point );
   }

	template < class Stream, class S >
   void write( Stream & stream, cg::color_t<S> const & c)
   {
      stream.write( &c, sizeof(c) );
   }

	template < class Stream, class S >
   void read( Stream & stream, cg::color_t<S> & c )
   {
      stream.read( c );
   }

	template < class Stream, class S >
   void write( Stream & stream, cg::colora_t<S> const & c)
   {
      stream.write( &c, sizeof(c) );
   }

	template < class Stream, class S >
   void read( Stream & stream, cg::colora_t<S> & c )
   {
      stream.read( c );
   }

   template < class Stream, class S, size_t D >
   void write( Stream & stream, cg::segment_t<S, D> const & seg )
   {
      stream.write( &seg, sizeof(seg) );
   }

   template < class Stream, class S, size_t D >
   void read( Stream & stream, cg::segment_t<S, D> & seg )
   {
      stream.read( seg );
   }

   // serialization
   template < class Stream, typename S >
   void write( Stream & stream, const cg::cpr_t < S > & data )
   {
      write( stream, data.course );
      write( stream, data.pitch  );
      write( stream, data.roll   );
   }

   template < class Stream, typename S >
   void read ( Stream & stream, cg::cpr_t < S > & data )
   {
      read ( stream, data.course );
      read ( stream, data.pitch  );
      read ( stream, data.roll   );
   }

   template < class Stream, typename S >
   void write( Stream & stream, const cg::dcpr_t < S > & data )
   {
      write( stream, data.dcourse );
      write( stream, data.dpitch  );
      write( stream, data.droll   );
   }

   template < class Stream, typename S >
   void read ( Stream & stream, cg::dcpr_t < S > & data )
   {
      read ( stream, data.dcourse );
      read ( stream, data.dpitch  );
      read ( stream, data.droll   );
   }

   template <class Stream, typename S >
   void write(Stream & stream, cg::range_t<S> const& data)
   {
      stream.write(&data, sizeof(data));
   }

   template <class Stream, typename S >
   void read(Stream & stream, cg::range_t<S>& data)
   {
      stream.read(data);
   }

   template <class Stream, typename S, size_t D >
   void write(Stream & stream, cg::rectangle_t<S,D> const& data)
   {
      stream.write(&data, sizeof(data));
   }

   template <class Stream, typename S, size_t D >
   void read(Stream & stream, cg::rectangle_t<S,D> & data)
   {
      stream.read(data);
   }

   template <class Stream>
   void write(Stream & stream, cg::glb_point_2 const& data)
   {
      stream.write(&data, sizeof(data));
   }

   template <class Stream>
   void write(Stream & stream, cg::glb_point_3 const& data)
   {
      stream.write(&data, sizeof(data));
   }

   template <class Stream>
   void read(Stream & stream, cg::glb_point_2 & data)
   {
      stream.read(data);
   }

   template <class Stream>
   void read(Stream & stream, cg::glb_point_3 & data)
   {
      stream.read(data);
   }
} // streams
