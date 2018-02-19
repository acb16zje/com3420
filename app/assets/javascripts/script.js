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

// DataTable
$(document).ready(function () {
    $('#myTable').DataTable();
});

// Pikaday
var picker = new Pikaday({
    field: document.getElementById('datepicker'),
    firstDay: 1,
    format: 'D-MMM-YYYY',
    minDate: new Date(),
    maxDate: new Date(2020, 12, 31),
    yearRange: [2000, 2020]
});