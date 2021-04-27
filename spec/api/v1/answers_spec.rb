require 'rails_helper'

describe 'post a answer route', type: :request do
  let(:access_token) { create(:access_token) }
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer_compare) { create(:answer, body: 'test_body', question: question, user: User.new) }

  before do

    post "/api/v1/questions/#{question.id}/answers", params: {
      format: :json, access_token: access_token.token,
      answer: { body: 'test_body', question_id: question.id, user_id: user.id }
    }
  end

  %w[body].each do |attr|
    it "answer object contains #{attr}" do
      expect(response.body).to be_json_eql(answer_compare.send(attr.to_sym).to_json).at_path(attr.to_s)
    end
  end

  it 'returns a created status' do
    expect(response).to have_http_status(:created)
  end
end

describe 'Answers API' do

  describe 'GET /index' do

    context 'unauthorized' do
      before {
        @user = create(:user)
        @question2 = create(:question, user: @user)
      }

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{@question2.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{@question2.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let!(:answers) { create_list(:answer, 2, { question: question, user: user }) }
      let!(:answer) { answers.first }
      let!(:comment) { create(:comment, commentable: answer, user_id: user.id) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w[id body created_at updated_at best].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
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
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('0/attachments')
        end

        %w[url].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("0/attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do

    context 'unauthorized' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, question: question, user: user) }

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question, user: user) }
      let!(:comment) { create(:comment, commentable: answer, user_id: user.id) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before {
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            params: { format: :json, access_token: access_token.token }
      }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      %w[id body created_at updated_at best].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w[view].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
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
