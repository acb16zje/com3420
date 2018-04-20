//= require jquery
//= require datatables
//= require jquery_ujs
//= require bulma.datatables
//= require bunny
//= require inputTypeNumberPolyfill
//= require notifications
//= require peripherals
//= require picker
//= require picker.date
//= require picker.time
//= require select2
//= require zoom
//= require handlebars
//= require_tree ./templates

$(document).ready(function () {
    // Dropdowns
    var $dropdowns = getAll('.dropdown:not(.is-hoverable)');

    if ($dropdowns.length > 0) {
        $dropdowns.forEach(function ($el) {
            $el.addEventListener('click', function (event) {
                event.stopPropagation();
                $el.classList.toggle('is-active');
            });
        });

        document.addEventListener('click', function (event) {
            $dropdowns.forEach(function ($el) {
                $el.classList.remove('is-active');
            });
        });
    }

    // Navigation Burger menu
    // Get all "navbar-burger" elements
    var $navbarBurgers = getAll('.navbar-burger');

    // Check if there are any navbar burgers
    if ($navbarBurgers.length > 0) {

        // Add a click event on each of them
        $navbarBurgers.forEach(function ($el) {
            $el.addEventListener('click', function () {

                // Get the target from the "data-target" attribute
                var target = $el.dataset.target;
                var $target = document.getElementById(target);

                // Toggle the class on both the "navbar-burger" and the "navbar-menu"
                $el.classList.toggle('is-active');
                $target.classList.toggle('is-active');

            });
        });
    }

    // Pickadate purchaseDate on creating assets
    $("#purchaseDate").pickadate({
        format: 'd mmmm yyyy',
        clear: ''
    });

    var startDate = $('#startDate');
    var endDate = $('#endDate');
    var startTime = $('#startTime');
    var endTime = $('#endTime');

    // Pickadate startDate on creating booking
    startDate.pickadate({
        format: 'd mmmm yyyy',
        clear: '',
        max: gon.max_start_date,
        onStart: function () {
            if (gon.initial_disable_dates.length !== 0) {
                this.set('disable', gon.initial_disable_dates);
            }

            if (moment().hour() == 23 && moment().minute() >= 50) {
                // this.set('select', moment().add(1, 'd').toDate());
                this.set('min', moment().add(1, 'd').toDate());
            } else {
                // this.set('select', moment());
                this.set('min', moment());
            }
        }
    });

    // Pickadate endDate on creating booking
    endDate.pickadate({
        format: 'd mmmm yyyy',
        clear: '',
        min: moment(),
        onStart: function () {
            if (gon.max_end_date.length !== 0) {
                this.set('max', gon.max_end_date)
            }

            if (gon.initial_disable_dates.length !== 0) {
                this.set('disable', gon.initial_disable_dates);
            }

            endDate.prop('disabled', true);
        }
    });

    // Timepicker startTime on creating booking
    startTime.pickatime({
        clear: '',
        min: moment(),
        interval: 10,
        onStart: function () {
            startTime.prop('disabled', true);
        }
    });

    // Timepicker endTime on creating booking
    endTime.pickatime({
        clear: '',
        min: moment(),
        interval: 10,
        onStart: function () {
            endTime.prop('disabled', true);
        }
    });

    $('.datepicker').change(function () {
        if ($(this).attr('id') === 'startDate') {
            var start_date = new Date(startDate.val());
            var end_date = new Date(endDate.val());

            // Do not allow endDate to be smaller than start date
            if (end_date < start_date && endDate.val()) {
                endDate.pickadate('picker').clear();
            }

            endDate.pickadate('picker').set('min', start_date);

            // If the start date is today, set the minimum start time to now
            if (moment().format('D MMMM YYYY') === startDate.val()) {
                startTime.pickatime('picker').set('min', moment());
            } else {
                startTime.pickatime('picker').set('min', false);
            }

            startTime.prop('disabled', false);
            startTime.pickatime('picker').clear();

            // Dynamic disable startTime when startDate is changed
            $.ajax({
                type: "GET",
                url: "start_date",
                data: {
                    start_date: new Date(startDate.val()),
                    end_date: new Date(endDate.val())
                },
                dataType: 'json',
                success: function (data) {
                    startTime.pickatime('picker').set('enable', true);
                    startTime.pickatime('picker').set('disable', data.disable_start_time);

                    if (data.max_end_date.length > 0) {
                        endDate.pickadate('picker').set('max', data.max_end_date);
                    } else {
                        endDate.pickadate('picker').set('max', false);
                    }
                }
            });
        } else {
            // Dynamic disable endTime when endDate is changed
            if (endDate.val()) {
                $.ajax({
                    type: "GET",
                    url: "end_date",
                    data: {
                        start_date: new Date(startDate.val()),
                        end_date: new Date(endDate.val()),
                        start_time: new Date(startDate.val() + ' ' + startTime.val())
                    },
                    dataType: 'json',
                    success: function (data) {
                        if (data.max_end_time.length > 0) {
                            endTime.pickatime('picker').set('max', data.max_end_time)
                        } else {
                            endTime.pickatime('picker').set('max', false)
                        }
                    }
                });
            }
        }

        // Prevent user to input smaller endTime than startTime
        disableEndInput();
        checkTimes();
    });

    // Prevent endTime smaller than startTime on the same date
    startTime.change(function () {
        disableEndInput();
        checkTimes();

        if (endDate.val()) {
            endDate.pickadate('picker').clear();
        }
    });

    // Clear the endTime when endDate is changed, for checking peripherals purposes
    endDate.change(function () {
        if (endTime.val()) {
            endTime.pickatime('picker').clear();
        }
    });

    // Prevent peripherals selection unless all dates and times are filled
    endTime.change(function () {
        disablePeripherals();
    });

    // Check the time when timepicker is changed
    function checkTimes() {
        var start_date = startDate.val();
        var end_date = endDate.val();

        // Check if end time is larger than start time on the same date
        if (start_date === end_date || end_date === '') {
            var start_time = new Date(start_date + ' ' + startTime.val());
            var end_time = new Date(end_date + ' ' + endTime.val());

            // If start time is 11:50 PM, then end date must be the next day
            if (startTime.val() === "11:50 PM") {
                end_date = moment(new Date(start_date)).add(1, 'd');
                endDate.pickadate('picker').set('min', moment(end_date).toDate());

                // Clear the endDate when startTime is changed
                if (endDate.val()) {
                    endDate.pickadate('picker').clear();
                }
            } else {
                endDate.pickadate('picker').set('min', start_date);
                endDate.pickadate('picker').set('highlight', start_date);
            }

            // Do not allow end time to be smaller than start time on the same date
            if (end_time <= start_time && end_time) {
                endTime.pickatime('picker').clear();
            }

            // Clear the endTime when startTime is changed
            if (endTime.val()) {
                endTime.pickatime('picker').clear();
            }

            // If end date is empty, then end time has no minimum
            if (endDate.val()) {
                endTime.pickatime('picker').set('min', moment(start_time).add(10, 'm').toDate());
            } else {
                endTime.pickatime('picker').set('min', false);
            }
        } else {
            // Start date is larger than end date
            endTime.pickatime('picker').set('min', false);

            // If start time is 11:50 PM, disable the option for end date to be start date
            if (startTime.val() !== "11:50 PM") {
                endDate.pickadate('picker').set('min', moment(new Date(start_date)).toDate());

                if (endDate.val() === '') {
                    endDate.pickadate('picker').set('highlight', moment(new Date(start_date)).toDate());
                }
            }
        }
    }

    // Disable end date and end time input
    function disableEndInput() {
        // Disable the end date and end time if start date and start time are not filled
        if (startDate.pickadate('picker') != undefined &&
            (startDate.pickadate('picker').get() == '' ||
                startTime.pickatime('picker').get() == '')) {
            endDate.prop('disabled', true);
            endTime.prop('disabled', true);
        } else {
            endDate.prop('disabled', false);
            endTime.prop('disabled', false);
        }
    }

    // Disable peripherals
    disablePeripherals();

    function disablePeripherals() {
        // Disable the peripherals unless all dates and times are filled
        var peripherals = $('#peripherals');

        if (startDate.pickadate('picker') != undefined &&
            (startDate.pickadate('picker').get() == '' ||
                startTime.pickatime('picker').get() == '' ||
                endDate.pickadate('picker').get() == '' ||
                endTime.pickatime('picker').get() == '')) {

            peripherals.prop('disabled', true);
        } else {
            peripherals.prop('disabled', false);
        }

        if (peripherals.val()) {
            peripherals.val(null).trigger('change');
        }
    }

    // Bulma notification
    $(document).on('click', '.notification > button.delete', function () {
        this.parentNode.remove();
    });

    // Datatable
    $("#users, #categories, #bookings").each(function () {
        $(this).DataTable({
            "drawCallback": function (settings) {
                if (!$(this).parent().hasClass("table-is-responsive")) {
                    $(this).wrap('<div class="table-is-responsive"></div>');
                }
            }
        });
    });


    function format ( d ) {
      console.log(d.items)
      var html = HandlebarsTemplates['booking_details']({
        items: d.items
      });
  //     var html = ('<div class="row-details">' +
  // '<h3>Items On Booking:</h3>'+
  //   '<table>' +
  //     '<thead>' +
  //       '<tr>' +
  //         '<th> ID </th>' +
  //         '<th> Name </th>' +
  //       '</tr>' +
  //     '</thead>' +
  //     '<tbody>');
  //       for (var i in d.items){
  //         html += ('<tr>' +
  //           '<td>'+ d.items[i].item_id +'</td>' +
  //           '<td>'+ d.items[i].item_name +'</td>' +
  //         '</tr>');
  //       }
  //       html += (
  //     '</tbody>' +
  //   '</table> ' + '</div>');
    return html
    }

    var dt = $('#example').DataTable( {
       processing: true,
       serverSide: true,
       ajax: $('#example').data('url'),
       aoColumns: [
         {
             "title": "Details",
             "targets": 0,
             "className": 'details-control',
             "orderable": false,
             // "data": null,
             "defaultContent": '',
             "render": function () {
                 return '<i class="fa fa-plus-square" aria-hidden="true"></i>';
             },
             width:"15px"
         },
          { "mDataProp": "id" },
          { "mDataProp": "start_date" },
          { "mDataProp": "start_time" },
          { "mDataProp": "end_date" },
          { "mDataProp": "end_time" },
          { "mDataProp": "reason" },
          { "mDataProp": "next_location" },
          { "mDataProp": "status" },
          { "mDataProp": "user_id" }
        ],
        order: [[1, 'asc']],
        searching: false
     });

    // Array to track the ids of the details displayed rows
    var detailRows = [];

    $('#example tbody').on( 'click', 'tr td.details-control', function () {
        var tr = $(this).closest('tr');
        var row = dt.row( tr );
        var idx = $.inArray( tr.attr('id'), detailRows );

        if ( row.child.isShown() ) {
            tr.removeClass( 'details' );
            row.child.hide();

            // Remove from the 'open' array
            detailRows.splice( idx, 1 );
        }
        else {
            tr.addClass( 'details' );
            row.child( format( row.data() ) ).show();

            // Add to the 'open' array
            if ( idx === -1 ) {
                detailRows.push( tr.attr('id') );
            }
        }
    } );

    // On each draw, loop over the `detailRows` array and show any child rows
    dt.on( 'draw', function () {
        $.each( detailRows, function ( i, id ) {
            $('#'+id+' td.details-control').trigger( 'click' );
        } );
    } );













    $("#bookings_other_wrapper").removeClass("container");

    // For searching browse by categories
    var table = $("#assets").DataTable({
        "drawCallback": function (settings) {
            if (!$(this).parent().hasClass("table-is-responsive")) {
                $(this).wrap('<div class="table-is-responsive"></div>');
            }
        }
    });



    // Use gon to get ruby variables into JS, for categories filtering
    if (gon.category != null) {
        table.search(gon.category).draw();
    }

    // Select2
    $.fn.select2.defaults.set("width", "100%");
    $('.select2').select2();

    endTime.change(function() {
        $('#peripherals').empty();
    });

    $('#peripherals').change(function() {
        if (endTime.val()) {
            $.ajax({
                type: "GET",
                url: "peripherals",
                data: {
                    start_datetime: startDate.val() + ' ' + startTime.val(),
                    end_datetime: endDate.val() + ' ' + endTime.val(),
                },
                dataType: 'json',
                success: function (data, page) {
                    // console.log('Peripherals ajax');
                    // console.log(data);
                    // console.log(data.name);

                    $('#peripherals').select2({
                        data: $.map(data, function (item, i) {
                            return {
                                id: item.id,
                                text: item.name + " (" + item.serial + ")"
                            }
                        })
                    })
                }
            });
        }
    });

    // Phone number validation
    var number = document.getElementById("number");
    if (number != null) {
        inputTypeNumberPolyfill.polyfillElement(number);
    }

    // Image upload show file name
    $('#item_image').change(function () {
        var i = $(this).prev('label').clone();
        var file = $('#item_image')[0].files[0].name;
        $("#file_name").text(file);
    });

    // Zoom.js config
    $('#zoom').zoom({
        magnify: 0.8
    });

    // Launch and close the modal
    function getAll(selector) {
        return Array.prototype.slice.call(document.querySelectorAll(selector), 0);
    }

    var modals = getAll('.modal');
    var modalButtons = getAll('.modal-button');
    var modalCloses = getAll('.modal-close');

    // Open the modal
    if (modalButtons.length > 0) {
        modalButtons.forEach(function ($el) {
            $el.addEventListener('click', function () {
                var target = $el.dataset.target;
                var $target = document.getElementById(target);
                $target.classList.add('is-active');
            });
        });
    }

    // Close modal button
    if (modalCloses.length > 0) {
        modalCloses.forEach(function ($el) {
            $el.addEventListener('click', function () {
                closeModals();
            });
        });
    }

    // Close modal when Esc is pressed
   $(document).keydown(function () {
       var e = event || window.event;
       if (e.keyCode === 27) {
           closeModals();
       }
   });

    // Close modal when click outside of image
   $(document).click(function (e) {
       if (!$(e.target).closest(".image-modal").length && !$(e.target).closest(".modal-button").length) {
           closeModals();
       }
   });

    // closeModals function
   function closeModals() {
       modals.forEach(function ($el) {
           $el.classList.remove('is-active');
       });
   }
});
