from tastypie.api import Api

from memopol.meps.api import MEPCountryResource,\
                             MEPLocalPartyResource,\
                             MEPGroupResource,\
                             MEPDelegationResource,\
                             MEPCommitteeResource,\
                             MEPBuildingResource,\
                             MEPOrganizationResource,\
                             MEPMEPResource,\
                             MEPGroupMEPResource,\
                             MEPDelegationRoleResource,\
                             MEPCommitteeRoleResource,\
                             MEPPostalAddressResource,\
                             MEPCountryMEPResource,\
                             MEPOrganizationMEPResource

from memopol.mps.api import MPFunctionResource,\
                            MPDepartmentResource,\
                            MPCirconscriptionResource,\
                            MPCantonResource,\
                            MPGroupResource,\
                            MPFunctionMPResource,\
                            MPAddressResource,\
                            MPPhoneResource,\
                            MPMandateResource,\
                            MPMPResource

from memopol.votes.api import ProposalResource,\
                              RecommendationResource,\
                              VoteResource,\
                              ScoreResource,\
                              RecommendationDataResource

from memopol.reps.api import REPPartyResource,\
                             REPOpinionResource,\
                             REPRepresentativeResource,\
                             REPPartyRepresentativeResource,\
                             REPEmailResource,\
                             REPCVResource,\
                             REPWebSiteResource,\
                             REPOpinionREPResource

v1_api = Api(api_name='v1')

v1_api.register(MEPCountryResource())
v1_api.register(MEPLocalPartyResource())
v1_api.register(MEPGroupResource())
v1_api.register(MEPDelegationResource())
v1_api.register(MEPCommitteeResource())
v1_api.register(MEPBuildingResource())
v1_api.register(MEPOrganizationResource())
v1_api.register(MEPMEPResource())
v1_api.register(MEPGroupMEPResource())
v1_api.register(MEPDelegationRoleResource())
v1_api.register(MEPCommitteeRoleResource())
v1_api.register(MEPPostalAddressResource())
v1_api.register(MEPCountryMEPResource())
v1_api.register(MEPOrganizationMEPResource())

v1_api.register(MPFunctionResource())
v1_api.register(MPDepartmentResource())
v1_api.register(MPCirconscriptionResource())
v1_api.register(MPCantonResource())
v1_api.register(MPGroupResource())
v1_api.register(MPFunctionMPResource())
v1_api.register(MPAddressResource())
v1_api.register(MPPhoneResource())
v1_api.register(MPMandateResource())
v1_api.register(MPMPResource())

v1_api.register(ProposalResource())
v1_api.register(RecommendationResource())
v1_api.register(VoteResource())
v1_api.register(ScoreResource())
v1_api.register(RecommendationDataResource())

v1_api.register(REPPartyResource())
v1_api.register(REPOpinionResource())
v1_api.register(REPRepresentativeResource())
v1_api.register(REPPartyRepresentativeResource())
v1_api.register(REPEmailResource())
v1_api.register(REPCVResource())
v1_api.register(REPWebSiteResource())
v1_api.register(REPOpinionREPResource())
