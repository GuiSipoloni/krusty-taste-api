def load_json(file_name)
  JSON.parse(File.open(File.expand_path('.')+"/spec/fixtures/#{file_name}.json").read).deep_symbolize_keys
end