$(document).ready(function() {
    // Function to adjust layout based on window size
    function adjustLayout() {
        var windowWidth = window.innerWidth;
        var mainElement = document.querySelector('main');
        var sidebarChapterElement = document.querySelector('.sidebar-chapter');
        var sidebarBookElement = document.querySelector('.sidebar-book');
        var containerElement = document.querySelector('.container-fluid');

        if (windowWidth < 992) {
            sidebarChapterElement.classList.add('d-none');
            sidebarBookElement.classList.add('d-none');
            mainElement.classList.remove('col-md-9', 'col-lg-7');
            mainElement.classList.add('col-12');
            containerElement.style.maxWidth = '60%';
        } else if (windowWidth < 1100) {
            sidebarChapterElement.classList.add('d-none');
            sidebarBookElement.classList.add('d-none');
            mainElement.classList.remove('col-md-9', 'col-lg-7');
            mainElement.classList.add('col-12');
            containerElement.style.maxWidth = '75%';
            mainElement.style.maxWidth = '50%';
        } else if (windowWidth < 1400) {
            sidebarChapterElement.classList.add('d-none');
            sidebarBookElement.classList.add('d-none');
            mainElement.classList.remove('col-md-9', 'col-lg-7');
            mainElement.classList.add('col-12');
            containerElement.style.maxWidth = '75%';
            mainElement.style.maxWidth = '60%';
        } else {
            sidebarChapterElement.classList.remove('d-none');
            sidebarChapterElement.classList.add('col-lg-3');
            sidebarBookElement.classList.remove('d-none');
            sidebarBookElement.classList.add('col-lg-2');
            mainElement.classList.remove('col-12', 'col-md-9');
            mainElement.classList.add('col-lg-7');
            containerElement.style.maxWidth = '90%';
            mainElement.style.maxWidth = '60%';
        }
    }

    // Adjust layout on window resize
    window.addEventListener('resize', adjustLayout);

    // Initial call to set layout
    adjustLayout();
});
