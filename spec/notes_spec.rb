require 'rails_helper'

# GET TESTS
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
  it 'returns only notes belonging to user' do
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
  it 'returns status code success' do
    expect(response).to have_http_status(:success)
  end
end

describe "get an unauthorized note route", :type => :request do
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
    sign_in(User.second)
    get root_path
    get "/api/v1/notes/#{note_id}"
  end
  it 'returns status unauthorized' do
    expect(response).to have_http_status(:unauthorized)
  end
end


# POST TESTS

describe "post a note", :type => :request do
  before do
    testing_user = FactoryBot.create(:user)
    sign_in(testing_user)
    @created_note = FactoryBot.build(:note)
    # sign in as the first generated user
    get root_path
    post "/api/v1/notes", params: {note: @created_note.as_json}
  end
  it 'returns the note with matching title' do
    expect(JSON.parse(response.body)['title']).to eq(@created_note.as_json['title'])
  end
  it 'returns the note with matching body' do
    expect(JSON.parse(response.body)['body']).to eq(@created_note.as_json['body'])
  end
  it 'returns status created' do
    expect(response).to have_http_status(:created)
  end
end

describe "post a note without both title and body ", :type => :request do
  before do
    testing_user = FactoryBot.create(:user)
    sign_in(testing_user)
    @count = Note.count
    @created_note = Note.new(title: "", body: "")
    # sign in as the first generated user
    get root_path
    post "/api/v1/notes", params: {note: @created_note.as_json}
  end
  it 'does not go into the note count' do
    expect(@count).to eq(Note.count)
  end
  it 'returns status 422' do
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

describe "post a note with 1000 characters in the body and no title", :type => :request do
  before do
    testing_user = FactoryBot.create(:user)
    sign_in(testing_user)
    @title = "0"*30
    @created_note = Note.new(title: "", body: "0"*1000)
    # sign in as the first generated user
    get root_path
    @count = Note.count
    post "/api/v1/notes", params: {note: @created_note.as_json}
  end
  it 'returns the note with matching title' do
    expect(JSON.parse(response.body)['title']).to eq(@title)
  end
  it 'returns the note with matching body' do
    expect(JSON.parse(response.body)['body']).to eq(@created_note.as_json['body'])
  end
  it 'returns status created' do
    expect(response).to have_http_status(:created)
  end
end

describe "post a note with 1001 characters in the body", :type => :request do
  before do
    testing_user = FactoryBot.create(:user)
    sign_in(testing_user)
    @created_note = Note.new(title: "", body: "0"*1001)
    # sign in as the first generated user
    get root_path
    @count = Note.count
    post "/api/v1/notes", params: {note: @created_note.as_json}
  end
  it 'does not go into the note count' do
    expect(@count).to eq(Note.count)
  end
  it 'returns status 422' do
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

describe "post a note with 31 characters in the title", :type => :request do
  before do
    testing_user = FactoryBot.create(:user)
    sign_in(testing_user)
    @created_note = Note.new(title: "0"*31, body: "")
    # sign in as the first generated user
    get root_path
    @count = Note.count
    post "/api/v1/notes", params: {note: @created_note.as_json}
  end
  it 'does not go into the note count' do
    expect(@count).to eq(Note.count)
  end
  it 'returns status 422' do
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

# PUTS
describe "put a unowned note", :type => :request do
  before do
    testing_user = FactoryBot.create(:user)
    @note = FactoryBot.build(:note)
    @note.user = testing_user
    @note.save

    # sign in as another user and attempt to update unowned id
    testing_user_2 = FactoryBot.create(:user)
    sign_in(testing_user_2)
    @created_note = Note.new(title: "0", body: "0")
    get root_path
    put "/api/v1/notes/#{@note.id}", params: {note: @created_note.as_json}
  end
  it 'does not change the note' do
    persisted_note = Note.find(@note.id)
    expect(persisted_note.as_json['body']).not_to eq(@created_note.as_json['body'])
  end
  it 'returns status unauthorized' do
    expect(response).to have_http_status(:unauthorized)
  end
end

describe "put an owned note", :type => :request do
  before do
    testing_user = FactoryBot.create(:user)
    @note = FactoryBot.build(:note)
    @note.user = testing_user
    @note.save

    sign_in(testing_user)
    @created_note = Note.new(title: "0", body: "0")
    get root_path
    put "/api/v1/notes/#{@note.id}", params: {note: @created_note.as_json}
  end
  it 'does not change the note' do
    persisted_note = Note.find(@note.id)
    expect(persisted_note.as_json['body']).to eq(@created_note.as_json['body'])
  end
  it 'returns status ok' do
    expect(response).to have_http_status(:ok)
  end
end

# delete
describe "delete an unowned note", :type => :request do
  before do
    testing_user = FactoryBot.create(:user)
    @note = FactoryBot.build(:note)
    @note.user = testing_user
    @note.save
    @note_count = Note.count
    # sign in as another user and attempt to delete unowned id
    testing_user_2 = FactoryBot.create(:user)
    sign_in(testing_user_2)
    get root_path
    delete "/api/v1/notes/#{@note.id}"
  end
  it 'does not change the note count' do
    persisted_note_count = Note.count
    expect(persisted_note_count).to eq(@note_count)
  end
  it 'returns status unauthorized' do
    expect(response).to have_http_status(:unauthorized)
  end
end

describe "delete an owned note", :type => :request do
  before do
    testing_user = FactoryBot.create(:user)
    @note = FactoryBot.build(:note)
    @note.user = testing_user
    @note.save
    @note_count = Note.count
    # sign in as another user and attempt to delete unowned id
    sign_in(testing_user)
    get root_path
    delete "/api/v1/notes/#{@note.id}"
  end
  it 'does change the note count' do
    persisted_note_count = Note.count
    expect(persisted_note_count).to eq(@note_count-1)
  end
  it 'returns status no content' do
    expect(response).to have_http_status(:no_content)
  end
end
