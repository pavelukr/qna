require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question, { user: @user }) }

  describe 'GET #show' do
    let(:answer) { create(:answer, { question: question, user: @user }) }
    before { get :show, params: { id: answer, question_id: question.id, user_id: @user.id } }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id, user_id: @user.id } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect do
          post :create, params: { answer: { body: 'MyText' },
                                  question_id: question.id, user_id: @user.id }
        end
          .to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { answer: { body: nil },
                                  question_id: question.id, user_id: @user.id }
        end
          .to_not change(question.answers, :count)
      end
    end
  end


  describe 'DELETE #destroy' do
    let(:answer) { create(:answer, { question: question, user: @user }) }
    before { answer }

    it 'deletes answer' do
      expect do
        delete :destroy, params: { id: answer, question_id: question.id,
                                   user_id: @user.id }, format: :js
      end
        .to change(Answer, :count).by(-1)
    end
  end

  describe 'PATCH #select_best' do
    let!(:answer) { create(:answer, question: question, user: @user) }
    let!(:best_answer) { create(:answer, question: question, user: @user, best: true) }

    it 'change best answer' do
      patch :select_best, params: { question_id: question.id, answer_id: answer.id, format: :js }

      answer.reload
      best_answer.reload
      expect(answer.best).to eq true
      expect(best_answer.best).to eq false
    end
  end

  describe 'PATCH #delete_attachment' do
    let(:answer) { create(:answer, question: question, user: @user) }
    let(:attachment) { create(:attachment, { attachable: answer }) }

    context 'valid attributes' do
      it 'assigns requested answer to @answer' do
        patch :delete_attachment, params: { question_id: question.id, answer_id: answer.id,
                                            attachment_id: attachment.id }
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns requested attachment to @attachment' do
        patch :delete_attachment, params: { question_id: question.id, answer_id: answer.id,
                                            attachment_id: attachment.id }
        expect(assigns(:attachment)).to eq attachment
      end

      it 'deletes attachment' do
        answer2 = create(:answer, { question: question, user: @user, attachments: [attachment] })
        answer1 = create(:answer, { question: question, user: @user, attachments: [attachment] })
        patch :delete_attachment, params: { question_id: question.id, answer_id: answer1.id,
                                            attachment_id: attachment.id }
        answer1.reload
        expect(answer1.attachments[0]).to_not eq answer2.attachments[0]
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question, user: @user) }

    it 'assings the requested answer to @answer' do
      patch :update, params: { id: answer, answer: { body: 'MyText' },
                               question_id: question.id, user_id: @user.id, format: :js }
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, params: { id: answer, answer: { body: 'MyText' },
                               question_id: question.id, user_id: @user.id, format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer, answer: { body: 'new body' },
                               question_id: question.id, user_id: @user.id, format: :js }
      answer.reload
      expect(answer.body).to eq 'new body'
    end
  end

  context 'commenting' do

    let!(:instance) { create(:answer, question: question, user: User.new) }
    let!(:instance2) { create(:answer, question: question, user: @user) }

    describe 'POST #like' do

      before { do_request_like }

      it_behaves_like 'Like vote'

      def do_request_like
        post :like, params: { answer_id: instance.id, question_id: question.id, format: :json }
      end

      def do_request_same_user
        post :like, params: { answer_id: instance2.id, question_id: question.id, format: :json }
      end
    end

    describe 'POST #dislike' do

      before { do_request_dislike }

      it_behaves_like 'Dislike vote'

      def do_request_dislike
        post :dislike, params: { answer_id: instance.id, question_id: question.id, format: :json }
      end

      def do_request_same_user
        post :dislike, params: { answer_id: instance2.id, question_id: question.id, format: :json }
      end
    end

    describe 'DELETE #destroy' do
      let!(:vote) { create(:vote, votable: instance, user_id: @user.id) }

      it_behaves_like 'Unvote'

      before do
        do_request_unvote
      end

      def do_request_unvote
        delete :unvote, params: { answer_id: instance.id, question_id: question.id, format: :json }
      end
    end
  end

  context 'commenting' do

    let!(:instance) { create(:answer, question: question, user: @user) }

    describe 'POST #create_comment' do
      it_behaves_like 'Leave comment'

      before { do_request_create_comment }

      def do_request_create_comment
        post :create_comment, params: { answer_id: instance.id, question_id: question.id, view: 'NewView' }
      end
    end

    describe 'DELETE #delete_comment' do
      let!(:comment) { create(:comment, commentable: instance, user_id: @user.id) }

      it_behaves_like 'Delete Comment'

      before do
        do_request_delete_comment
      end

      def do_request_delete_comment
        delete :delete_comment, params: { answer_id: instance.id, question_id: question.id, format: :json }
      end
    end
  end
end
