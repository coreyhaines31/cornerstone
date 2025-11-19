# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, :https, :data
  policy.object_src  :none
  policy.script_src  :self, :https
  policy.style_src   :self, :https

  # Allow @vite/client to hot reload JavaScript changes in development
  if Rails.env.development?
    policy.connect_src :self, :https, "http://localhost:3036", "ws://localhost:3036"
    policy.script_src  :self, :https, :unsafe_eval, "http://localhost:3036"
  else
    policy.connect_src :self, :https
  end
end

# Generate session nonces for permitted importmap and inline scripts
Rails.application.config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
Rails.application.config.content_security_policy_nonce_directives = %w(script-src)

# Report violations without enforcing the policy.
# Rails.application.config.content_security_policy_report_only = true
