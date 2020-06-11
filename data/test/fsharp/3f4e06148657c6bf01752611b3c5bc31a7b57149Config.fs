namespace ProjectI.Api

open IdentityServer4
open IdentityServer4.Models
open System.Collections.Generic

module Config = 
    let GetIdentityResources (): IEnumerable<IdentityResource> =
        [| 
            IdentityResources.OpenId() :> IdentityResource; 
            IdentityResources.Profile() :> IdentityResource 
        |] :> IEnumerable<IdentityResource>

    let GetApiResources (): IEnumerable<ApiResource> =
        [| ApiResource("api", "ProjectI") |] :> IEnumerable<ApiResource>

    let GetClients (): IEnumerable<Client> = 
        [|
            Client(
                ClientId = "mvc",
                ClientName = "MVC Client",
                AllowedGrantTypes = GrantTypes.HybridAndClientCredentials,

                RequireConsent = true,

                ClientSecrets = [|Secret("secret".Sha256())|],

                RedirectUris = [| "http://localhost:5002/signin-oidc" |],
                PostLogoutRedirectUris = [| "http://localhost:5002/signout-callback-oidc" |],

                AllowedScopes =
                    [|
                        IdentityServerConstants.StandardScopes.OpenId;
                        IdentityServerConstants.StandardScopes.Profile;
                        "api1";
                    |]
                ,
                AllowOfflineAccess = true
            )
        |] :> IEnumerable<Client>
