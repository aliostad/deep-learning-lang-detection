module UseCases
  class MakeOfferRequest
    include ::SolidUseCase

    steps :validate, :store, :dump

    def initialize(offer_request_repository            = OfferRequests::OfferRequestRepository.new,
                   category_repository                 = Juices::Categories::CategoryRepository.new,
                   delivery_repository                 = OfferRequests::Deliveries::DeliveryRepository.new,
                   offer_request_read_model_repository = OfferRequests::ReadModel::OfferRequestReadModelRepository.new)
      @offer_request_repository            = offer_request_repository
      @category_repository                 = category_repository
      @delivery_repository                 = delivery_repository
      @offer_request_read_model_repository = offer_request_read_model_repository
      @validate_offer_request              = OfferRequests::ValidateOfferRequest.new(category_repository, delivery_repository)
    end

    def validate(offer_requests_params)
      continue validate_offer_request.(offer_requests_params)
    rescue OfferRequests::ValidateOfferRequest::InvalidOfferRequest => e
      fail e.kind, e.errors
    end

    def store(offer_request_form_object)
      continue offer_request_repository.save(offer_request_form_object)
    end

    def dump(offer_request)
      continue offer_request_read_model_repository.save(offer_request)
    end

    private
    attr_reader :offer_request_repository,
                :category_repository,
                :delivery_repository,
                :offer_request_read_model_repository,
                :validate_offer_request
  end
end
