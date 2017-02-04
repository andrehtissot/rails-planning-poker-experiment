json.array!(@participants) do |participant|
  json.extract! participant, :id, :name, :birthday, :function, :sex
  json.url participant_url(participant, format: :json)
end
