$(document).ready(function () {
    $('.edit-answer-link').click(function (e) {
        e.preventDefault();
        $(this).hide();
        let answer_id = $(this).data('answerId');
        $('form#edit-answer-' + answer_id).show();
    });

    $('.vote-answer-link').click(function (e) {
        e.preventDefault();
        $(this).hide();
        let flag = $(this).data('flag');
        let answer_id = $(this).data('answerId');
        const body = $('#body_answer_' + answer_id);
        if(!flag){
            body.find('.link-for-deleting').show();
        }else{
            body.find('.links-for-voting').show();
        }
    });

    $('.vote-for-answer-link').click(function (e) {
        e.preventDefault();
        let question_id = $(this).data('questionId');
        let answer_id = $(this).data('answerId');
        $.ajax({
            url: window.location.origin + `/questions/${question_id}/answers/${answer_id}/like`,

            type: "POST",
            dataType: 'json',
            data: {},
            success: function (response) {
                const body = $('#body_answer_' + answer_id);
                body.find('.rating-div').html('');
                body.find('.rating-div').append('Rating: ' + response);

                body.find('.links-for-voting').hide();
                body.find('.link-for-deleting').show();
            },
            error: function (err) {
            }
        })
    });

    $('.vote-against-answer-link').click(function (e) {
        e.preventDefault();
        let answer_id = $(this).data('answerId');
        let question_id = $(this).data('questionId');
        $.ajax({
            url: window.location.origin + `/questions/${question_id}/answers/${answer_id}/dislike`,

            type: "POST",
            dataType: 'json',
            data: {},
            success: function (response) {
                const body = $('#body_answer_' + answer_id);
                body.find('.rating-div').html('');
                body.find('.rating-div').append('Rating: ' + response);

                body.find('.links-for-voting').hide();
                body.find('.link-for-deleting').show();
            },
            error: function (err) {
            }
        })
    });

    $('.vote-delete-answer-link').click(function (e) {
        e.preventDefault();
        let question_id = $(this).data('questionId');
        let answer_id = $(this).data('answerId');
        $.ajax({
            url: window.location.origin + `/questions/${question_id}/answers/${answer_id}/unvote`,

            type: "DELETE",
            dataType: 'json',
            data: {},
            success: function (response) {
                const body = $('#body_answer_' + answer_id);
                body.find('.rating-div').html('');
                body.find('.rating-div').append('Rating: ' + response);

                body.find('.links-for-voting').show();
                body.find('.link-for-deleting').hide()
            },
            error: function (err) {
            }
        })
    });
})