/*import Turbolinks from "turbolinks"
Turbolinks.start()*/

$(document).ready(function () {
    $('.edit-question-link').click(function (e) {
        e.preventDefault();
        $(this).hide();
        let question_id = $(this).data('questionId');
        $('form#edit-question-' + question_id).show();
    });



    // $('.vote-question-link').bind
    // 'ajax:success', (e)
    // debugger
    // {
    //     let question_id = $(this).data('questionId');
    //     $('#body_question_<%= @question.id %>').replaceWith('<%= j render @question %>');
    // }


        $('.vote-question-link').click(function (e) {
            e.preventDefault();
            let question_id = $(this).data('questionId');
            $.ajax({
                url: window.location.origin + `/questions/${question_id}/like`,
                method: "POST",
                dataType: 'json',
                data: {},
                success: function (response) {

                },
                error: function (err) {
                }
            })
        })
});