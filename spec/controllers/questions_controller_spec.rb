require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  sign_in_user
  let(:question) { create(:question, { user: @user }) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, { user: @user }) }

    before { get :index }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do

    before { get :edit, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: { title: 'MyString', body: 'MyText' } } }.to change(Question, :count).by(1)
      end

      it 'renders show view' do
        post :create, params: { question: { title: 'MyString', body: 'MyText' } }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: { title: nil, body: nil } } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: { title: nil, body: nil } }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

    context 'valid attributes' do
      it 'assigns requested question to @question' do
        patch :update, params: { id: question, question: { title: 'MyString', body: 'MyText' }, format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'newString', body: 'newText' }, format: :js }
        question.reload
        expect(question.title).to eq 'newString'
        expect(question.body).to eq 'newText'
      end
    end
  end

  describe 'PATCH #delete_attachment' do
    let(:attachment) { create(:attachment, { attachable: question }) }

    context 'valid attributes' do
      it 'assigns requested question to @question' do
        patch :delete_attachment, params: { question_id: question.id, attachment_id: attachment.id }
        expect(assigns(:question)).to eq question
      end

      it 'assigns requested attachment to @attachment' do
        patch :delete_attachment, params: { question_id: question.id, attachment_id: attachment.id }
        expect(assigns(:attachment)).to eq attachment
      end

      it 'deletes attachment' do
        question2 = create(:question, { user: @user, attachments: [attachment] })
        question1 = create(:question, { user: @user, attachments: [attachment] })
        patch :delete_attachment, params: { question_id: question1.id, attachment_id: attachment.id }
        question1.reload
        expect(question1.attachments[0]).to_not eq question2.attachments[0]
      end
    end
  end

  describe 'DELETE #destroy' do
    before { question }

    it 'deletes question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
