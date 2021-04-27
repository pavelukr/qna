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
                                  question_id: question.id, user_id: @user.id, format: :js }
        end
          .to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { answer: { body: nil },
                                  question_id: question.id, user_id: @user.id, format: :js }
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
end
