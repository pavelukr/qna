shared_examples_for 'Like vote' do

  it 'the author can not put a like' do
    do_request_same_user
    expect(assigns(:instance)).to eq instance2
    expect(instance2.votes.length).to eq 0
    expect(instance2.votes.last).to eq nil
  end

  context 'send like' do
    it 'assigns requested instance to instance' do
      expect(assigns(:instance)).to eq instance
    end
    it 'expects to change array length of votes' do
      expect(instance.votes.length).to eq 1
    end

    it 'expects to have opinion to be equal 1' do
      instance.votes.reload
      expect(instance.votes.last.opinion).to eq 1
    end
  end
end

shared_examples_for 'Dislike vote' do
  it 'the author can not put a dislike' do
    do_request_same_user
    expect(assigns(:instance)).to eq instance2
    expect(instance2.votes.length).to eq 0
    expect(instance2.votes.last).to eq nil
  end

  context 'send dislike' do
    it 'assigns requested instance to instance' do
      expect(assigns(:instance)).to eq instance
    end
    it 'expects to change array length of votes' do
      expect(instance.votes.length).to eq 1
    end

    it 'expects to have opinion to be equal -1' do
      instance.votes.reload
      expect(instance.votes.last.opinion).to eq -1
    end
  end
end

shared_examples_for 'Unvote' do
  context 'delete vote' do
    it 'assigns requested instance to instance' do
      expect(assigns(:instance)).to eq instance
    end
    it 'expects to change array length of votes' do
      expect(instance.votes.length).to eq 0
    end

    it 'expects to not have vote' do
      expect(instance.votes.last).to eq nil
    end
  end
end
