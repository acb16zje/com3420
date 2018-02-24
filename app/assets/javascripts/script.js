// Navigation Burger menu
document.addEventListener('DOMContentLoaded', function () {

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

});

$(document).ready(function () {
    // Datatable
    $('#fullfeatures').DataTable({
        "drawCallback": function (settings) {
            if (!$("#fullfeatures").parent().hasClass("table-is-responsive")) {
                $("#fullfeatures").wrap('<div class="table-is-responsive"></div>');
            }
        }
    });

    // Select2
    $.fn.select2.defaults.set("width", "100%");
    $('.select2').select2();
});
