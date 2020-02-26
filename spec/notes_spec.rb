require 'rails_helper'

describe "get all notes route", :type => :request do
  before do
    # create 5 users, with 5 notes
    5.times do
      user = FactoryBot.create(:user)
      5.times do
        note1 = FactoryBot.build(:note)
        note1.user = user
        note1.save
      end
    end
    # sign in as the first generated user
    sign_in(User.first)
    get root_path
    get '/api/v1/notes'
  end
  it 'returns all relevant notes' do
    expect(JSON.parse(response.body).size).to eq(5)
  end
  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end

describe "get a note route", :type => :request do
  before do
    # create 5 users, with 5 notes
    5.times do
      user = FactoryBot.create(:user)
      5.times do
        note1 = FactoryBot.build(:note)
        note1.user = user
        note1.save
      end
    end
    testing_user = User.first
    @first_note = testing_user.notes.first
    note_id = testing_user.notes.first.id
    # sign in as the first generated user
    sign_in(testing_user)
    get root_path
    get "/api/v1/notes/#{note_id}"
  end
  it 'returns the note with matching values' do
    expect(JSON.parse(response.body).values).to eq(@first_note.as_json.values)
  end
  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end