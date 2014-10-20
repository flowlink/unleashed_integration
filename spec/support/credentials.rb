def sample_credentials
  begin
    # Add your testing credentials to credentials.yml
    YAML.load_file("credentials.yml")
  rescue Errno::ENOENT
    {
      "api_id"  => 'app_id',
      "api_key" => 'api_key',
      "api_url" => 'api_url',
    }
  end
end