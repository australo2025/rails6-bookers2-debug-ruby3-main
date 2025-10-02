class EventMailer < ApplicationMailer
  def event_email(user, group, title, content)
    @user    = user
    @group   = group
    @title   = title
    @content = content

    mail(to: @user.email, subject: "[#{@group.name}] #{title}")
  end
end