/*import Turbolinks from "turbolinks"
Turbolinks.start()*/

$(document).ready(function () {
    $('.edit-question-link').click(function (e) {
        e.preventDefault();
        $(this).hide();
        let question_id = $(this).data('questionId');
        $('form#edit-question-' + question_id).show();
    });

    $('.vote-for-question-link').click(function (e) {
        e.preventDefault();
        let question_id = $(this).data('questionId');
        $('form#edit-question-' + question_id).show();
    });
});