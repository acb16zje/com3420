//= require jquery_ujs
//= require bulma.datatables
//= require bunny
//= require inputTypeNumberPolyfill
//= require picker
//= require picker.date
//= require picker.time
//= require zoom
//= require notifications

$(document).ready(function () {
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
        clear: '',
        onStart: function () {
            var date = new Date();
            this.set('select', [date.getFullYear(), date.getMonth(), date.getDate()]);
        }
    });

    // Pickadate startDate on creating booking
    $('#startDate').pickadate({
        format: 'd mmmm yyyy',
        clear: '',
        // An integer (positive/negative) sets it relative to today.
        min: new Date(),
        onStart: function () {
            var date = new Date();
            this.set('select', [date.getFullYear(), date.getMonth(), date.getDate()]);
        },
        disable: gon.block_dates
    });

    // Pickadate endDate on creating booking
    $('#endDate').pickadate({
        format: 'd mmmm yyyy',
        clear: '',
        min: new Date(),
        onStart: function () {
            var date = new Date();
            this.set('select', [date.getFullYear(), date.getMonth(), date.getDate()]);
        },
        disable: gon.block_dates
    });

    $('.datepicker').on('change', function () {
        if ($(this).attr('id') === 'startDate') {
            var startDate = new Date($('#startDate').val());
            var endDate = new Date($('#endDate').val());
            if (endDate < startDate) {
                $('#endDate').val($('#startDate').val());
            }
            $('#endDate').pickadate('picker').set('min', $(this).val());
        }

        // Prevent user to input smaller endTime than startTime
        checkTimes();
    });

    // Timepicker startTime on creating booking
    $('#startTime').pickatime({
        clear: '',
        min: [9, 0],
        max: [17, 0],
        interval: 10,
        disable: gon.block_start_time
    });

    // Timepicker endTime on creating booking
    $('#endTime').pickatime({
        clear: '',
        min: [9, 0],
        max: [17, 0],
        interval: 10,
        disable: gon.block_end_time
    });

    // Dynamic disable startTime when startDate is changed
    $('#startDate').on('change', function () {
        $.ajax({
            type: "GET",
            url: "new",
            data: {
                start_date: $('#startDate').val(),
            },
            dataType: 'json',
            success: function (data) {
                $('#startTime').pickatime('picker').set('enable', true);
                $('#startTime').pickatime('picker').set('disable', data.block_start_time);
            }
        });
    });

    // Dynamic disable endTime when endDate is changed
    $('#endDate').on('change', function () {
        $.ajax({
            type: "GET",
            url: "new",
            data: {
                end_date: $('#endDate').val(),
            },
            dataType: 'json',
            success: function (data) {
                $('#endTime').pickatime('picker').set('enable', true);
                $('#endTime').pickatime('picker').set('disable', data.block_end_time);
            }
        })
    });

    // Prevent endTime smaller than startTime on the same date
    $('.timepicker').on('change', function () {
        checkTimes();
    });

    function checkTimes() {
        var startDate = $('#startDate').val();
        var endDate = $('#endDate').val();

        // if ($(this).attr('id') === 'startTime') {
            if (startDate === endDate) {
                var startTime = new Date(startDate + ' ' + $('#startTime').val());
                var endTime = new Date(endDate + ' ' + $('#endTime').val());
                if (endTime <= startTime) {
                    $('#endTime').val(moment(moment(startTime).add(10, 'm').toDate()).format('h:mm A'));
                }

                // Prevent same startTime and endTime
                $('#endTime').pickatime('picker').set('min', moment(startTime).add(10, 'm').toDate());
            } else {
                $('#endTime').pickatime('picker').set('val', '');
                $('#endTime').pickatime('picker').set('min', [9, 0]);
            }
        // }
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

    // Browse by categories
    var table = $("#assets").DataTable({
        "drawCallback": function (settings) {
            if (!$(this).parent().hasClass("table-is-responsive")) {
                $(this).wrap('<div class="table-is-responsive"></div>');
            }
        }
    });

    // Use gon to get ruby variables into JS
    if (gon.category != null) {
        table.search(gon.category).draw();
    }

    // Select2
    $.fn.select2.defaults.set("width", "100%");
    $('.select2').select2();

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