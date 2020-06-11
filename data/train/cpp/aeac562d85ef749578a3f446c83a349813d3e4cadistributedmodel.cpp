
/*
 * Chooses an implementation of DistributedModel based on wheter we are
 * using MPI or not.
 */

#ifndef SINGLEPROC
#include "distributedmodel_mp.cpp"
#else
#include "distributedmodel_sp.cpp"
#endif


template class DistributedModel<1>;
template class DistributedModel<2>;
template class DistributedModel<3>;
template class DistributedModel<4>;

/*
template void DistributedModel<1>::ShareDistribution(DistributedModel<1>::Ptr other)
template void DistributedModel<1>::ShareDistribution(DistributedModel<2>::Ptr other)
template void DistributedModel<1>::ShareDistribution(DistributedModel<3>::Ptr other)
template void DistributedModel<1>::ShareDistribution(DistributedModel<4>::Ptr other)
*/
