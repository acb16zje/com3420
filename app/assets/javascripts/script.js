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

    $('#purchaseDate').pickadate({
       format: 'd mmmm yyyy'
    });
});

// Bulma notification
$(document).on('click', '.notification > button.delete', function () {
    this.parentNode.remove();
});

$(document).ready(function () {
    // Datatable
    $('#assets').DataTable({
        "drawCallback": function (settings) {
            if (!$("#assets").parent().hasClass("table-is-responsive")) {
                $("#assets").wrap('<div class="table-is-responsive"></div>');
            }
        }
    });

    $('#users').DataTable({
        "drawCallback": function (settings) {
            if (!$("#users").parent().hasClass("table-is-responsive")) {
                $("#users").wrap('<div class="table-is-responsive"></div>');
            }
        }
    });

    // Select2
    $.fn.select2.defaults.set("width", "100%");
    $('.select2').select2();
});