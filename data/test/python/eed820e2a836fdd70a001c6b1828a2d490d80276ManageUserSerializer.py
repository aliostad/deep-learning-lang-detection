from restapi.models.ManageUser import ManageUser
from restapi.serializers.BaseModelSerializer import BaseModelSerializer


class ManageUserSerializer(BaseModelSerializer):
    # pylint: disable=unused-argument
    def create(self, *args, **kwargs):
        raise Exception('Can not create anything in', self.__class__.__name__)

    # pylint: disable=unused-argument
    def update(self, *args, **kwargs):
        raise Exception('Can not update anything in', self.__class__.__name__)

    # pylint: disable=old-style-class
    class Meta:
        model = ManageUser
        fields = ('user_id',
                  'full_name')
