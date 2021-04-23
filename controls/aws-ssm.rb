# control 'aws_ssm_secure_parameters' do
#   title 'Passwords should be encrypted'
#   impact 1.0

#   describe aws_ssm_parameter(name: '/some/password/key') do
#     its('type') { should eq 'SecureString' }
#   end
# end
