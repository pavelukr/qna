/*import Turbolinks from "turbolinks"
Turbolinks.start()*/

$(document).ready(function () {

    $('.ask-new-question').click(function (e) {
        e.preventDefault();
        $(this).hide();
        $('form#new_question').show();
    });

    $('.submit-form-new').click(function (e) {
        $('form#new_question').hide();
        $('.ask-new-question').show();
    });

    $('.edit-question-link').click(function (e) {
        e.preventDefault();
        $(this).hide();
        let question_id = $(this).data('questionId');
        $('form#edit-question-' + question_id).show();
    });

    $('.vote-question-link').click(function (e) {
        e.preventDefault();
        $(this).hide();
        let flag = $(this).data('flag');
        let question_id = $(this).data('questionId');
        const body = $('#body_question_' + question_id);
        if(!flag){
            body.find('.link-for-deleting').show();
        }else{
            body.find('.links-for-voting').show();
        }
    });

        $('.vote-for-question-link').click(function (e) {
            e.preventDefault();
            let question_id = $(this).data('questionId');
            $.ajax({
                url: window.location.origin + `/questions/${question_id}/like`,

                type: "POST",
                dataType: 'json',
                data: {},
                success: function (response) {
                    const body = $('#body_question_' + question_id);
                    body.find('.rating-div').html('');
                    body.find('.rating-div').append('Rating: ' + response);

                    body.find('.links-for-voting').hide();
                    body.find('.link-for-deleting').show();
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

            type: "POST",
            dataType: 'json',
            data: {},
            success: function (response) {
                const body = $('#body_question_' + question_id);
                body.find('.rating-div').html('');
                body.find('.rating-div').append('Rating: ' + response);

                body.find('.links-for-voting').hide();
                body.find('.link-for-deleting').show();
            },
            error: function (err) {
            }
        })
    });

    $('.vote-delete-question-link').click(function (e) {
        e.preventDefault();
        let question_id = $(this).data('questionId');
        $.ajax({
            url: window.location.origin + `/questions/${question_id}/unvote`,

            type: "DELETE",
            dataType: 'json',
            data: {},
            success: function (response) {
                const body = $('#body_question_' + question_id);
                body.find('.rating-div').html('');
                body.find('.rating-div').append('Rating: ' + response);

                body.find('.links-for-voting').show();
                body.find('.link-for-deleting').hide()
            },
            error: function (err) {
            }
        })
    });
});