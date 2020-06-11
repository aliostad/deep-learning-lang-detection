module Codnar

  module Configuration

    # Weave configuration providing a single simple +include+ template.
    WEAVE_INCLUDE = { "include" => "<%= chunk.expanded_html %>\n" }

    # Weave chunks in the plainest possible way.
    WEAVE_PLAIN_CHUNK = {
      "plain_chunk" => <<-EOF.unindent, #! ((( html
        <div class="plain chunk">
        <a name="<%= chunk.name.to_id %>"/>
        <%= chunk.expanded_html %>
        </div>
      EOF
    } #! ))) html

    # Weave chunks with their name and the list of container chunks.
    WEAVE_NAMED_CHUNK_WITH_CONTAINERS = {
      "named_chunk_with_containers" => <<-EOF.unindent, #! ((( html
        <div class="named_with_containers chunk">
        <div class="chunk name">
        <a name="<%= chunk.name.to_id %>">
        <span><%= CGI.escapeHTML(chunk.name) %></span>
        </a>
        </div>
        <div class="chunk html">
        <%= chunk.expanded_html %>
        </div>
        % if chunk.containers != []
        <div class="chunk containers">
        <span class="chunk containers header">Contained in:</span>
        <ul class="chunk containers">
        % chunk.containers.each do |container|
        <li class="chunk container">
        <a class="chunk container" href="#<%= container.to_id %>"><%= CGI.escapeHTML(container) %></a>
        </li>
        % end
        </ul>
        </div>
        % end
        </div>
      EOF
    } #! ))) html

  end

end
