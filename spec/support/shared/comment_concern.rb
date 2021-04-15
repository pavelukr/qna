shared_examples_for 'Leave comment' do

  context 'send like' do
    it 'assigns requested instance to instance' do
      expect(assigns(:instance)).to eq instance
    end
    it 'expects to change array length of comments' do
      expect(instance.comments.length).to eq 1
    end

    it 'expects to have view to be equal NewView' do
      instance.votes.reload
      expect(instance.comments.last.view).to eq 'NewView'
    end
  end
end

shared_examples_for 'Delete Comment' do
  context 'delete comment' do
    it 'assigns requested instance to instance' do
      expect(assigns(:instance)).to eq instance
    end
    it 'expects to change array length of comments' do
      expect(instance.votes.length).to eq 0
    end

    it 'expects to not have comment' do
      expect(instance.votes.last).to eq nil
    end
  end
end
