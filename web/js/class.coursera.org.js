$(function ($) {

    var handlers = {};

    var handle = function (titles, handler) {
        if (typeof titles === 'string')
            titles = [titles];

        var i = titles.length;
        while (i-- > 0) {
            var t = titles[i];
            (handlers[t] = handlers[t] || []).push(handler);
        }
    };

    var videoTitles = ['Video Lectures', 'Videos (inc. lectures)'];

    // Videos progress counts.
    handle(videoTitles, function () {
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
    handle(videoTitles, function () {
        $('div.course-lecture-item-resource')
            .prepend(function (i) {
                return '<a class=view-btn href="' +
                        this.previousElementSibling.dataset.modalIframe +
                        '" target=video-view>' +
                        '<i class="icon-eye-open resource"></i>' +
                        '<div class=hidden>View the lecture in new page</div>' +
                        '</a>';
            })
            .on('click', '.view-btn', function () {
                $(this).closest('li').addClass('viewed');
            });
    });

    // More informative and better section headers.
    handle(videoTitles, function () {
        $('div.course-item-list-header > h3')
            .append(function (i, html) {
                var mins = 0, secs = 0, lectureLinks = this
                        .parentNode
                        .nextSibling
                        .querySelectorAll('.unviewed > a.lecture-link');

                for (var i = lectureLinks.length - 1; i >= 0; i--) {
                    var match = lectureLinks[i]
                        .innerText.match(/\((\d\d?):(\d\d)\)$/);
                    if (match) {
                        mins += parseInt(match[1], 10);
                        secs += parseInt(match[2], 10);
                    }
                }

                mins += Math.round(secs / 60);

                var hours = Math.floor(mins / 60);
                mins = mins % 60;

                if (mins >= 55) {
                    hours += 1;
                    mins = 0;
                }

                return '<span style=float:right;margin-right:6px>' +
                    (hours || mins ? '~ ' : '') +
                    (hours ? hours + ' hour(s)' : '') +
                    (hours && mins ? ', ' : '') +
                    (mins ? mins + ' min(s)' : '') +
                    (hours || mins ? ' needed' : '') +
                    '</span> <br style=clear:both>';
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
        'Home': 'home',
        'Home - Announcements': 'home',
        'Welcome to the Course': 'flag',
        'Course Schedule': 'calendar',
        'Tips for Working in Coursera': 'list-alt',
        'Viewing the Video Lectures': 'film',
        'Video Lectures': 'facetime-video',
        'Discussion Forums': 'comment',
        'Resources': 'book',
        'Learning Resources': 'book',
        'Additional Documents': 'file',
        'Quizzes': 'edit',
        'Assignments': 'check',
        'Programming Assignments': 'check',
        'Exams': 'pencil',
        'Syllabus': 'tasks',
        'About the Instructors': 'user',
        'Course Wiki': 'eye-close'
    };

    $('li.course-navbar-item > a').prepend(function (i) {
        var icon = iconMap[this.innerText];
        return icon ? '<i class=icon-' + icon + '></i>' : null;
    });

});
