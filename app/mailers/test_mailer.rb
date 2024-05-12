class TestMailer < ApplicationMailer
  default from: 'jjdevacc@careclan.life'

  def hello
    mail(
      subject: 'Hello from Postmark',
      to: 'jjdevacc@careclan.life',
      from: 'jjdevacc@careclan.life',
      html_body: '<strong>Hello</strong> dear Postmark user.',
      track_opens: 'true',
      message_stream: 'broadcast'
    )
  end
end
