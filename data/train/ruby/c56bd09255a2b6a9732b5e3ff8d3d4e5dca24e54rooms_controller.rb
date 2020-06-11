class RoomsController
  class Index
    include RoomReservation::Action
    expose :rooms

    def initialize(repository: RoomRepository)
      @repository = repository
    end

    def call(params)
      @rooms = @repository.sorted_by_name
    end
  end

  class Show
    include RoomReservation::Action

    def initialize(repository: RoomRepository)
      @repository = repository
    end

    def call(params)
      @model = @repository.find(params.fetch(:id))
    end
  end

  class New
    include RoomReservation::Action
    expose :form

    def call(params)
      @form = RoomsFormFactory.create
    end
  end

  class Create
    include RoomReservation::Action
    expose :form

    def initialize(repository: RoomRepository)
      @repository = repository
    end

    def call(params)
      @form = RoomsFormFactory.create
      room  = @form.populate(params.fetch(:room), self)
      @repository.persist(room)
      redirect_to @router.path(:rooms)
    end

    def form_invalid
      halt 422
    end
  end

  class Edit
    include RoomReservation::Action
    expose :form

    def initialize(repository: RoomRepository)
      @repository = repository
    end

    def call(params)
      @form = RoomsFormFactory.update(@repository.find(params.fetch(:id)))
    end
  end

  class Update
    include RoomReservation::Action
    expose :form

    def initialize(repository: RoomRepository)
      @repository = repository
    end

    def call(params)
      @form = RoomsFormFactory.update(@repository.find(params.fetch(:id)))
      room  = @form.populate(params.fetch(:room), self)
      @repository.persist(room)
      redirect_to @router.path(:rooms)
    end

    def form_invalid
      halt 422
    end
  end

  class Destroy
    include RoomReservation::Action
    def initialize(repository: RoomRepository)
      @repository = repository
    end

    def call(params)
      room = @repository.find(params.fetch(:id))
      @repository.delete(room)
      redirect_to @router.path(:rooms)
    end
  end
end
