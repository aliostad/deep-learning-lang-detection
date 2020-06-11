class KeventerConnector

#  KEVENTER_URL = "http://keventer-test.herokuapp.com"
  KEVENTER_URL = "http://keventer.herokuapp.com"
  API_ROOT = KEVENTER_URL + "/api"
  API_EVENTS_PATH = "/events.xml"
  API_COMMUNITY_EVENTS_PATH = "/community_events.xml"
  API_KLEERERS_PATH = "/kleerers.xml"
  API_CATEGORIES_PATH = "/categories.xml"

  def events_xml_url
      API_ROOT + API_EVENTS_PATH
  end

  def community_events_xml_url
      API_ROOT + API_COMMUNITY_EVENTS_PATH
  end

  def kleerers_xml_url
    API_ROOT + API_KLEERERS_PATH
  end

  def categories_xml_url
    API_ROOT + API_CATEGORIES_PATH
  end

  def event_type_url(event_type_id)
    API_ROOT + "/event_types/#{event_type_id}.xml"
  end

  def keventer_url
    KEVENTER_URL
  end

end
