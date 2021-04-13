control 'aws_region' do
  title 'The default region should exist'
  impact 1.0

  describe aws_region(ENV['AWS_DEFAULT_REGION']) do
    it { should exist }
  end
end
