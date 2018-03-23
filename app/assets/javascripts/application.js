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
            this.set('select', moment());
        }
    });

    var startDate = $('#startDate');
    var endDate = $('#endDate');
    var startTime = $('#startTime');
    var endTime = $('#endTime');

    // Pickadate startDate on creating booking
    startDate.pickadate({
        format: 'd mmmm yyyy',
        clear: '',
        min: moment(),
        disable: gon.block_start_dates,
        onStart: function () {
            this.set('select', moment());
        }
    });

    // Pickadate endDate on creating booking
    endDate.pickadate({
        format: 'd mmmm yyyy',
        clear: '',
        min: moment(),
        disable: gon.block_end_dates,
        onStart: function () {
            this.set('select', moment());
            this.set('max', gon.max_end_date);
        },
    });

    // Timepicker startTime on creating booking
    startTime.pickatime({
        clear: '',
        min: moment(),
        interval: 10,
        disable: gon.block_start_time
    });

    // Timepicker endTime on creating booking
    endTime.pickatime({
        clear: '',
        min: moment(),
        interval: 10,
        max: gon.max_end_time
    });

    $('.datepicker').on('change', function () {
        if ($(this).attr('id') === 'startDate') {
            var start_date = new Date(startDate.val());
            var end_date = new Date(endDate.val());
            if (end_date < start_date) {
                endDate.val(startDate.val());
            }
            endDate.pickadate('picker').set('min', $(this).val());

            if (moment().format('D MMMM YYYY') === startDate.val()) {
                startTime.pickatime('picker').set('min', moment());
            } else {
                startTime.pickatime('picker').set('min', '');
            }

            // Dynamic disable startTime when startDate is changed
            $.ajax({
                type: "GET",
                url: "new",
                data: {
                    start_date: $('#startDate').val(),
                },
                dataType: 'json',
                success: function (data) {
                    // console.log(data.end_date)
                    startTime.pickatime('picker').set('enable', true);
                    startTime.pickatime('picker').set('disable', data.block_start_time);
                    checkTimes();

                    endDate.pickadate('picker').set('enable', true);
                    endDate.pickadate('picker').set('max', data.max_end_date);
                    endDate.pickadate('picker').set('select',data.end_date);

                    endTime.pickatime('picker').set('enable', true);
                    endTime.pickatime('picker').set('max', data.max_end_time);

                }
            });
        } else {
            // Dynamic disable endTime when endDate is changed
            $.ajax({
                type: "GET",
                url: "new",
                data: {
                    end_date: $('#endDate').val(),
                },
                dataType: 'json',
                success: function (data) {
                    endTime.pickatime('picker').set('enable', true);
                    endTime.pickatime('picker').set('max', data.max_end_time);
                    checkTimes();
                }
            })

        }

        // Prevent user to input smaller endTime than startTime
    });

    // Prevent endTime smaller than startTime on the same date
    $('.timepicker').on('change', function () {
        if ($(this).attr('id') === 'startTime'){
            checkTimes();
        }
    });

    function checkTimes() {
        var start_date = startDate.val();
        var end_date = endDate.val();
        if (start_date === end_date) {
            var start_time = new Date(start_date + ' ' + startTime.val());
            var end_time = new Date(end_date + ' ' + endTime.val());

            // Prevent same startTime and endTime
            if ((end_time <= start_time)){
                endTime.val(moment(moment(start_time).add(10, 'm').toDate()).format('h:mm A'));
            }
            else {
                endTime.pickatime('picker').set('val', ''); 
            }
            endTime.pickatime('picker').set('min', moment(start_time).add(10, 'm').toDate());
        } else {
            console.log("asdasd")
            endTime.pickatime('picker').set('val', '');
            endTime.pickatime('picker').set('min', '');
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

    // For searching browse by categories
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