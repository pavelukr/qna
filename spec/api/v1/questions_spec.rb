require 'rails_helper'

describe 'post a question route', type: :request do

  it_behaves_like 'API Authenticable'

  let(:access_token) { create(:access_token) }
  let!(:user) { create(:user) }
  let!(:question_compare) { create(:question, title: 'test_title', body: 'test_body', user: User.new) }

  before do

    post '/api/v1/questions', params: {
      format: :json, access_token: access_token.token, question: { title: 'test_title', body: 'test_body', user_id: user.id }
    }
  end

  %w[title body].each do |attr|
    it "question object contains #{attr}" do
      expect(response.body).to be_json_eql(question_compare.send(attr.to_sym).to_json).at_path(attr.to_s)
    end
  end

  it 'returns a created status' do
    expect(response).to have_http_status(:created)
  end

  def do_request(options = {})
    post '/api/v1/questions', params: { format: :json }.merge(options)
  end
end

describe 'Questions API' do

  describe 'GET /index' do

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, { user: user }) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: user) }
      let!(:comment) { create(:comment, commentable: question, user_id: user.id) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/comments')
        end

        %w[view].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("0/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/attachments')
        end

        %w[url].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("0/attachments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do

    context 'unauthorized' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }

      it_behaves_like 'API Authenticable'

      def do_request(options = {})
        get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question, user: user) }
      let!(:comment) { create(:comment, commentable: question, user_id: user.id) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w[view].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        %w[url].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end
      end
    end
  end
end
