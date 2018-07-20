shared_context :clean_env do
  around :each do |spec|
    backup = ENV.to_hash
    spec.call
    ENV.each_key do |key|
      ENV.delete(key)
    end

    backup.each_key do |key|
      ENV[key] = backup[key]
    end
  end
end
