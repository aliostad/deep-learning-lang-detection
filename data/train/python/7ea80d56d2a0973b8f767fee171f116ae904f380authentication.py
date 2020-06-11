from tastypie.authentication import ApiKeyAuthentication
from accounts.models import ApiKey


class ManyApiKeyAuthentication(ApiKeyAuthentication):
    """Allow use many api keys for one user"""

    def get_key(self, user, api_key):
        """
        Attempts to find the API key for the user. Uses ``ApiKey`` by default
        but can be overridden.
        """
        try:
            ApiKey.objects.get(user=user, key=api_key)
        except ApiKey.DoesNotExist:
            return self._unauthorized()

        return True
