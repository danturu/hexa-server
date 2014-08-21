class NotificationMailer < ActionMailer::Base
  helper "mail"

  default from: "Hexa Space <no-reply@#{ENV['ACTION_MAILER_HOST']}>", template_path: "mailers/notifications"

  def invitation(game, email)
    @game = game
    mail to: email, subject: "[Hexa Space] Invitation from #{@game.game_owner.name}"
  end
end
