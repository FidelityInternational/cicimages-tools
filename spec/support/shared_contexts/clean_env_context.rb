shared_context :clean_env do
  around :each do |spec|
    backup = ENV.to_hash
    spec.call
    ENV.keys.each do |key|
      ENV.delete(key)
    end

    backup.keys.each do |key|
      ENV[key] = backup[key]
    end
  end
end
