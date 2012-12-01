$(function ($) {

    var handlers = {

        'Video Lectures': function () {
            var sectionCount = $('a.list_header_link').length,
                videoItems = $('li.item_row'),
                unviewedCount = videoItems.filter('.unviewed').length,
                viewedCount = videoItems.filter('.viewed').length,
                totalCount = videoItems.length,
                progressMarkup = '<div style=clear:both;padding:6px>';

            progressMarkup += viewedCount + ' done and ' + unviewedCount +
                ' remain of ' + totalCount + ' videos, put in ' +
                sectionCount + ' sections.';

            $('div.item_list').prev().before(progressMarkup + '</div>');
        },

        'Assignments': function () {
            var sectionCount = $('a.list_header_link').length,
                videoItems = $('li.item_row'),
                unviewedCount = videoItems.filter('.unviewed').length,
                viewedCount = videoItems.filter('.viewed').length,
                totalCount = videoItems.length,
                progressMarkup = '<div style=clear:both;padding:6px>';

            progressMarkup += viewedCount + ' done and ' + unviewedCount +
                ' remain of ' + totalCount + ' assignments.';

            $('div.item_list').prev().before(progressMarkup + '</div>');
        }

    };

    var page = $('#page-content h2').text();
    if (page in handlers) {
        handlers[page]();
    }

});
