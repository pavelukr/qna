/*import Turbolinks from "turbolinks"
Turbolinks.start()*/

$(document).ready(function () {
    $('.edit-question-link').click(function (e) {
        e.preventDefault();
        $(this).hide();
        let question_id = $(this).data('questionId');
        $('form#edit-question-' + question_id).show();
    });

        $('.vote-question-link').click(function (e) {
            e.preventDefault();
            let question_id = $(this).data('questionId');
            $.ajax({
                url: window.location.origin + `/questions/${question_id}/like`,

                method: "POST",
                dataType: 'json',
                data: {},
                success: function (response) {
                    const body = $('#body_question_' + question_id);
                    body.find('.rating-div').replaceWith('Rating: ' + response);

                    body.find('.links-for-voting').replaceWith(body.find('.link-for-deleting'));
                },
                error: function (err) {
                }
            })
        });

    $('.vote-against-question-link').click(function (e) {
        e.preventDefault();
        let question_id = $(this).data('questionId');
        $.ajax({
            url: window.location.origin + `/questions/${question_id}/dislike`,

            method: "POST",
            dataType: 'json',
            data: {},
            success: function (response) {
                const body = $('#body_question_' + question_id);
                body.find('.rating-div').replaceWith('Rating: ' + response);

                body.find('.links-for-voting').replaceWith(body.find('.link-for-deleting'));
            },
            error: function (err) {
            }
        })
    });

    $('.vote-delete-question-link').click(function (e) {
        e.preventDefault();
        let question_id = $(this).data('questionId');
        let vote_id = $(this).data('voteId');
        $.ajax({
            url: window.location.origin + `/questions/${question_id}/votes/${vote_id}`,

            method: "DELETE",
            dataType: 'json',
            data: {},
            success: function (response) {
                const body = $('#body_question_' + question_id);
                body.find('.rating-div').replaceWith('Rating: ' + response);

                body.find('.link-for-deleting').replaceWith(body.find('.links-for-voting'));
            },
            error: function (err) {
            }
        })
    });
});