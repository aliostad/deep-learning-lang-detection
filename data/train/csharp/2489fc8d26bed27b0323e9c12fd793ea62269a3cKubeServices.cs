using KubeApi.Apis.V1;
namespace Web.Services
{
    public class K8sServices
    {
        public K8sServices() { }
        public K8sServices(string kubeApiAddress)
        {
            ApiAddress = kubeApiAddress;
        }
        public string ApiAddress { get; set; }
        public BindingApi Binding { get { return new BindingApi(ApiAddress); } }
        public ComponentStatusApi ComponentStatus { get { return new ComponentStatusApi(ApiAddress); } }
        public ConfigMapApi ConfigMap { get { return new ConfigMapApi(ApiAddress); } }
        public EndpointApi Endpoint { get { return new EndpointApi(ApiAddress); } }
        public EventApi Event { get { return new EventApi(ApiAddress); } }
        public LimitRangeApi LimitRange { get { return new LimitRangeApi(ApiAddress); } }
        public NamespaceApi Namespace { get { return new NamespaceApi(ApiAddress); } }
        public NodeApi Node { get { return new NodeApi(ApiAddress); } }
        public PersistentVolumeApi PersistentVolume { get { return new PersistentVolumeApi(ApiAddress); } }
        public PersistentVolumeClaimApi PersistentVolumeClaim { get { return new PersistentVolumeClaimApi(ApiAddress); } }
        public PodApi Pod { get { return new PodApi(ApiAddress); } }
        public PodTemplateApi PodTemplate { get { return new PodTemplateApi(ApiAddress); } }
        public ReplicationControllerApi ReplicationController { get { return new ReplicationControllerApi(ApiAddress); } }
        public ResourceQuotaApi ResourceQuota { get { return new ResourceQuotaApi(ApiAddress); } }
        public SecretApi Secret { get { return new SecretApi(ApiAddress); } }
        public ServiceAccountApi ServiceAccount { get { return new ServiceAccountApi(ApiAddress); } }
        public ServiceApi Service { get { return new ServiceApi(ApiAddress); } }
    }
}
