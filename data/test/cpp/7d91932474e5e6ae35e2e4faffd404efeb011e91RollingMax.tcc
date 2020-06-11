
template<typename Sample>
void RollingMax<Sample>::operator()(Sample sample)
{
    
    Sample removedSample( 0.0 );
    if( cb.full() )
        removedSample = cb.front();
    
    cb.push_back( sample );
    
    if( removedSample == max && sample < max )
    {
        max = 0;
        for( size_t i = 0; i < cb.size(); i++ )
        {
            boost::numeric::max_assign( max, cb.at(i));
        }
    }
    boost::numeric::max_assign( max, sample );
}

template<typename Sample>
Sample RollingMax<Sample>::getMax()
{
    return max;
}
