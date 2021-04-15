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

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
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
      expect(response).to redirect_to '/'
    end
  end

  context 'voting' do

    let!(:instance) { create(:question, user: User.new) }
    let!(:instance2) { create(:question, user: @user) }

    describe 'POST #like' do

      before { do_request_like }

      it_behaves_like 'Like vote'

      def do_request_like
        post :like, params: { question_id: instance.id, format: :json }
      end

      def do_request_same_user
        post :like, params: { question_id: instance2.id, format: :json }
      end
    end

    describe 'POST #dislike' do

      before { do_request_dislike }

      it_behaves_like 'Dislike vote'

      def do_request_dislike
        post :dislike, params: { question_id: instance.id, format: :json }
      end

      def do_request_same_user
        post :dislike, params: { question_id: instance2.id, format: :json }
      end
    end

    describe 'DELETE #unvote' do
      let!(:vote) { create(:vote, votable: instance, user_id: @user.id) }

      it_behaves_like 'Unvote'

      before do
        do_request_unvote
      end

      def do_request_unvote
        delete :unvote, params: { question_id: instance.id, format: :json }
      end
    end
  end

  context 'commenting' do

    let!(:instance) { create(:question, user: @user) }

    describe 'POST #create_comment' do
      it_behaves_like 'Leave comment'

      before { do_request_create_comment }

      def do_request_create_comment
        post :create_comment, params: { question_id: instance.id, view: 'NewView' }
      end
    end

    describe 'DELETE #delete_comment' do
      let!(:comment) { create(:comment, commentable: instance, user_id: @user.id) }

      it_behaves_like 'Delete Comment'

      before do
        do_request_delete_comment
      end

      def do_request_delete_comment
        delete :delete_comment, params: { question_id: instance.id, format: :json }
      end
    end
  end
end
