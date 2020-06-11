<table id="apiLogList">
  <thead>
    <tr>
      <th>URL</th>
      <th>Call</th>
      <th>Partner</th>
      <th>API Partner</th>
      <th>Created</th>
			<th>Success</th>
    </tr>
  </thead>
  <tbody>
    <% _.each( apiLogs, function( apiLog) { %>
        <tr class="loadApiLog summaryRow" data-api-log-id=<%=apiLog.id%>>
          <td>
            <%=apiLog.url%>
          </td>
          <td>
            <%=apiLog.call%>
          </td>
          <td>
            <%=apiLog.partner%>
          </td>
          <td>
            <%=apiLog.apiPartner%>
          </td>
          <td>
            <%=apiLog.created%>
          </td>
          <td>
            <%=apiLog.success%>
          </td>
        </tr>
    <% }); %>
  </tbody>
</table>