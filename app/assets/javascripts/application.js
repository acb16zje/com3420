//= require jquery_ujs
//= require bulma.datatables
//= require bunny
//= require inputTypeNumberPolyfill
//= require picker
//= require picker.date
//= require zoom
//= require notifications

$(document).ready(function () {
    // Navigation Burger menu
    // Get all "navbar-burger" elements
    var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

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

    // Pickadate datepicker
    $("#purchaseDate").pickadate({
        format: 'd mmmm yyyy',
        clear: '',
        onStart: function () {
            var date = new Date()
            this.set('select', [date.getFullYear(), date.getMonth(), date.getDate()]);
        }
    });

    $('#startDate').pickadate({
        format: 'd mmmm yyyy',
        clear: '',
        // An integer (positive/negative) sets it relative to today.
        min: new Date(),
        onStart: function () {
            var date = new Date()
            this.set('select', [date.getFullYear(), date.getMonth(), date.getDate()]);
        },
        disable: gon.block_dates
    })

    $('#endDate').pickadate({
        format: 'd mmmm yyyy',
        clear: '',
        min: new Date(),
        onStart: function () {
            var date = new Date()
            this.set('select', [date.getFullYear(), date.getMonth(), date.getDate() + 1]);
        },
        disable: gon.block_dates
    })

    $('.datepicker').on('change', function () {
        if ($(this).attr('id') === 'startDate') {
            var startDate = new Date($('#startDate').val());
            var endDate = new Date($('#endDate').val());
            if (endDate < startDate) {
                $('#endDate').val("");
            }
            $('#endDate').pickadate('picker').set('min', $(this).val());
        }
    });

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
});
