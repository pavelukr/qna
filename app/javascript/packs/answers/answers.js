$(document).ready(function () {
    $('.edit-answer-link').click(function (e) {
        e.preventDefault();
        $(this).hide();
        let answer_id = $(this).data('answerId');
        $('form#edit-answer-' + answer_id).show();
    });
})