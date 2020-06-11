module DeployMonitor
  class Step
    attr_accessor :client, :step_id, :name, :description, :number

    def self.from_api(client, api_obj)
      step = self.new
      step.client = client
      step.update_from_api(api_obj)
      step
    end

    def api_url
      "#{@client.base_url}/steps/#{step_id}"
    end

    def web_url
      ""
    end

    def update_from_api(api_obj)
      self.step_id = api_obj['id']
      self.name = api_obj['name']
      self.description = api_obj['description']
      self.number = api_obj['number'] ? api_obj['number'].to_i : nil
    end
  end
end