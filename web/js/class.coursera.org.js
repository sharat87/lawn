$(function ($) {

    var handlers = {};

    var handle = function (title, handler) {
        if (!handlers[title])
            handlers[title] = [];
        handlers[title].push(handler);
    };

    // Videos progress counts.
    handle('Video Lectures', function () {
        var sectionCount = $('div.course-item-list-header').length,
            videoItems = $('ul.course-item-list-section-list > li'),
            unviewedCount = videoItems.filter('.unviewed').length,
            viewedCount = videoItems.filter('.viewed').length,
            totalCount = videoItems.length;

        progressMarkup = '<div style=clear:both;padding:6px>' + unviewedCount +
            ' remain and ' + viewedCount + ' are done. Of ' + totalCount +
            ' items, put in ' + sectionCount + ' sections.' + '</div>';

        $('div.course-item-list').prev().before(progressMarkup);
    });

    // Assignments progress counts.
    handle('Assignments', function () {
        var sectionCount = $('a.list_header_link').length,
            videoItems = $('li.item_row'),
            unviewedCount = videoItems.filter('.unviewed').length,
            viewedCount = videoItems.filter('.viewed').length,
            totalCount = videoItems.length,
            progressMarkup = '<div style=clear:both;padding:6px>';

        progressMarkup += viewedCount + ' done and ' + unviewedCount +
            ' remain of ' + totalCount + ' assignments.';

        $('div.item_list').prev().before(progressMarkup + '</div>');
    });

    // View video in new page buttons.
    handle('Video Lectures', function () {
        $('div.course-lecture-item-resource').prepend(function (i) {
            return '<a href="' +
                    this.previousElementSibling.dataset.lectureViewLink +
                    '" target=_blank>' +
                    '<i class="icon-eye-open resource"></i>' +
                    '<div class=hidden>View the lecture in new page</div>' +
                    '</a>';
        });
    });

    // A more informative title for video viewing page.
    handle('View', function () {
        document.title = document.getElementById('lecture_title').innerText +
            ' — Coursera View';
    });

    var page = $('#course-page-content h2').text() || document.title;
    if (page in handlers)
        for (var i = handlers[page].length; i-- > 0;)
            handlers[page][i]();

    // Fix the speed button in video view page.
    $(document.body).on('click', 'a[href=#]', function (e) {
        e.preventDefault();
    });

    // Add icons to left sidebar.
    var iconMap = {
        'Home - Announcements': 'flag',
        'Welcome to the Course': 'user',
        'Course Schedule': 'calendar',
        'Tips for Working in Coursera': 'list-alt',
        'Viewing the Video Lectures': 'film',
        'Video Lectures': 'facetime-video',
        'Discussion Forums': 'comment',
        'Resources': 'book',
        'Assignments': 'check',
        'Programming Assignments': 'check',
        'Exams': 'pencil',
        'Course Wiki': 'eye-close'
    };

    $('li.course-navbar-item > a').prepend(function (i) {
        var icon = iconMap[this.innerText];
        return icon ? '<i class=icon-' + icon + '></i>' : null;
    });

});
