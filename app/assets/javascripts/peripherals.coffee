# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/















# format = (d) ->
#   # `d` is the original data object for the row
#   '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">' +
#     '<tr>' +
#       '<td>ID:</td>' +
#       '<td>' + d.id + '</td>' +
#      '</tr>' +
#     '<tr>' +
#       '<td>Start Date:</td>' +
#       '<td>' + d.start_date + '</td>' +
#     '</tr>' +
#     '<tr>' +
#       '<td>Start Time:</td>' +
#       '<td>' + d.start_time + '</td>' +
#     '</tr>' +
#     '<tr>' +
#       '<td>End Date:</td>' +
#       '<td>' + d.end_date + '</td>' +
#     '</tr>' +
#     '<tr>' +
#       '<td>End Time:</td>' +
#       '<td>' + d.end_time + '</td>' +
#     '</tr>' +
#     '<tr>' +
#       '<td>Reason:</td>' +
#       '<td>' + d.reason + '</td>' +
#     '</tr>' +
#     '<tr>' +
#       '<td>Location:</td>' +
#       '<td>' + d.next_location + '</td>' +
#     '</tr>' +
#     '<tr>' +
#       '<td>Status:</td>' +
#       '<td>' + d.status + '</td>' +
#     '</tr>' +
#       '<td>User:</td>' +
#       '<td>' + d.user_id + '</td>' +
#     '</tr>' +
#
#   '</table>'
#
# $(document).ready ->
#
#
#
#
#   dt = $('#bookings_other').DataTable(
#     'ajax':
#       'dataType': 'json'
#       'type': 'GET'
#       'url': '/bookings/accepted.json'
#       'dataSrc': (json) ->
#         $.parseJSON json.d
#       'success': ->
#         console.log "success"
#       'error': -> console.log "fail"
#     'columns': [
#       { 'data': 'id' }
#       { 'data': 'start_date' }
#       { 'data': 'start_time' }
#       { 'data': 'end_date' }
#       { 'data': 'end_time' }
#       { 'data': 'reason' }
#       { 'data': 'next_location' }
#       { 'data': 'status' }
#       { 'data': 'user_id' }
#     ]
#     )
#     'drawCallback': function (settings) {
#                 if (!$(this).parent().hasClass("table-is-responsive")) {
#                     $(this).wrap('<div class="table-is-responsive"></div>');
#                 }
#             }
