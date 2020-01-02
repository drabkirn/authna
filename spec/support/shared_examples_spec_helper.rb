## Shared examples STATUS Messages START
shared_examples 'returns 200 success status' do
  it "returns 200 success status from response" do
    expect(response).to have_http_status(200)
  end

  it "returns 200 success status from json" do
    expect(json['status']).to eq 200
  end
end

shared_examples 'returns 201 created status' do
  it "returns 201 created status from response" do
    expect(response).to have_http_status(201)
  end

  it "returns 201 created status from json" do
    expect(json['status']).to eq 201
  end
end

shared_examples 'returns 302 redirection status' do
  it "returns 302 redirection status from response" do
    expect(response).to have_http_status(302)
  end
end

shared_examples 'returns 401 unauthorized status' do
  it "returns 401 unauthorized status from response" do
    expect(response).to have_http_status(401)
  end

  it "returns 401 unauthorized status from json" do
    expect(json['status']).to eq 401
  end
end

shared_examples 'returns 404 not found status' do
  it "returns 404 not found status from response" do
    expect(response).to have_http_status(404)
  end

  it "returns 404 not found status from json" do
    expect(json['status']).to eq 404
  end
end

shared_examples 'returns 422 unprocessable entity status' do
  it "returns 422 unprocessable entity status from response" do
    expect(response).to have_http_status(422)
  end

  it "returns 422 unprocessable entity status from json" do
    expect(json['status']).to eq 422
  end
end
## Shared examples STATUS Messages END

## CSRF Token START
shared_examples 'when csrf token is not present' do |action|
  before(:each) do
    ActionController::Base.allow_forgery_protection = true
    if action == 'create'
      post api_notes_path, params: valid_attributes.to_json, headers: v_headers
    elsif action == 'update'
      @new_title = Faker::Lorem.sentence(3)
      put api_note_path(valid_note_attributes[:id]), params: { title: @new_title }.to_json, headers: v_headers
    elsif action == 'destroy'
      delete api_note_path(valid_note_attributes[:id]), params: {}, headers: v_headers
    elsif action == '/auth/login'
      post '/auth/login', params: valid_credentials, headers: headers
    elsif action == '/auth/signup'
      post '/auth/signup', params: { user: valid_attributes }.to_json, headers: headers
    end
  end

  after(:each) do
    ActionController::Base.allow_forgery_protection = false
  end

  it "catches the error" do
    expect(json['errors']['message']).to eq Message.invalid_csrf_token
  end

  it_behaves_like 'returns 422 unprocessable entity status'
end
## CSRF TOken END

## Email Confirmation START
shared_examples 'when email is not confirmed' do |action|
  before(:each) do
    user2 = create(:user)
    note2 = create(:note, user_id: user2.id)
    if action == 'index' 
      get api_notes_path, params: {}, headers: valid_headers_with_user(user2)
    elsif action == 'show'
      get api_note_path(note2.id), params: { }, headers: valid_headers_with_user(user2)
    elsif action == 'create'
      post api_notes_path, params: valid_attributes.to_json, headers: valid_headers_with_user(user2)
    elsif action == 'update'
      @new_title = Faker::Lorem.sentence(3)
      put api_note_path(note2.id), params: { title: @new_title }.to_json, headers: valid_headers_with_user(user2)
    elsif action == 'destroy'
      delete api_note_path(note2.id), params: {}, headers: valid_headers_with_user(user2)
    end
  end

  it "returns email not confirmed message" do
    expect(json['errors']['message']).to eq Message.confirm_your_email
  end

  it_behaves_like 'returns 401 unauthorized status'
end
## Email Confirmation END