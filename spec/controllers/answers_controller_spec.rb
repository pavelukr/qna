require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #show' do
    let(:answer) { create(:answer, { question: question }) }
    before { get :show, params: { id: answer, question_id: question.id } }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

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
        expect { post :create, params: { answer: { body: 'MyText' }, question_id: question.id } }
          .to change(Answer, :count).by(1)
      end

      it 'renders show view' do
        post :create, params: { answer: { body: 'MyText' }, question_id: question.id }
        expect(response).to redirect_to question_path(question.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: { body: nil }, question_id: question.id } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: { body: nil }, question_id: question.id }
        expect(response).to redirect_to new_question_answer_path(question.id)
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, { question: question }) }

    context 'valid attributes' do
      it 'assigns requested answer to @answer' do
        patch :update, params: { id: answer, answer: { body: 'MyText' }, question_id: question.id }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'newText' }, question_id: question.id }
        answer.reload
        expect(answer.body).to eq 'newText'
      end

      it 'redirects to the updated answer' do
        patch :update, params: { id: answer, answer: { body: 'MyText' }, question_id: question.id }
        expect(response).to redirect_to question_answer_path
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: { body: nil }, question_id: question.id } }
      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit template' do
        expect(response).to render_template :edit
      end
    end
  end
end

