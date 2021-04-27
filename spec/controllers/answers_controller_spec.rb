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
      expect { delete :destroy, params: { id: answer, question_id: question.id, user_id: @user.id } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: answer, question_id: question.id, user_id: @user.id }
      expect(response).to redirect_to question
    end
  end
end

