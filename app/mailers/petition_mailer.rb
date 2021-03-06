class PetitionMailer < ApplicationMailer
  include ActiveSupport::NumberHelper

  def email_confirmation_for_signer(signature)
    @signature = signature
    mail to: @signature.email, subject: subject_for(:email_confirmation_for_signer)
  end

  def email_signer(petition, signature, email)
    @petition, @signature, @email = petition, signature, email
    mail to: @signature.email, subject: subject_for(:email_signer)
  end

  def special_resend_of_email_confirmation_for_signer(signature)
    @signature = signature
    mail to: @signature.email, subject: subject_for(:special_resend_of_email_confirmation_for_signer)
  end

  def notify_creator_that_petition_is_published(signature)
    @petition = signature.petition
    @signature = signature
    mail to: @signature.email, subject: subject_for(:notify_creator_that_petition_is_published)
  end

  def notify_sponsor_that_petition_is_published(signature)
    @petition = signature.petition
    @signature = signature
    mail to: @signature.email, subject: subject_for(:notify_sponsor_that_petition_is_published)
  end

  def petition_rejected(petition)
    @petition, @rejection = petition, petition.rejection
    to = @petition.creator_signature.email
    bcc = @petition.sponsor_signatures.validated.map(&:email)
    mail to: to, bcc: bcc, subject: subject_for(:petition_rejected)
  end

  def notify_signer_of_threshold_response(petition, signature)
    @petition, @signature = petition, signature
    mail to: @signature.email, subject: subject_for(:notify_signer_of_threshold_response)
  end

  def notify_creator_of_closing_date_change(signature)
    @signature = signature
    mail to: @signature.email, subject: subject_for(:notify_creator_of_closing_date_change)
  end

  def gather_sponsors_for_petition(petition)
    @petition, @creator = petition, petition.creator_signature
    mail to: @creator.email, subject: subject_for(:gather_sponsors_for_petition)
  end

  def notify_signer_of_debate_outcome(petition, signature)
    @petition = petition
    @signature = signature
    mail(
      subject: subject_for(:notify_signer_of_debate_outcome),
      to: @signature.email
    )
  end

  def notify_signer_of_debate_scheduled(petition, signature)
    @petition = petition
    @signature = signature
    mail(
      subject: subject_for(:notify_signer_of_debate_scheduled),
      to: @signature.email
    )
  end

  private

  def subject_for(key, options = {})
    I18n.t key, i18n_options.merge(options)
  end

  def i18n_options
    {}.tap do |options|
      options[:scope] = :"petitions.emails.subjects"

      if defined?(@petition)
        options[:count] = @petition.signature_count
        options[:formatted_count] = number_to_delimited(@petition.signature_count)
        options[:action] = @petition.action
      end

      if defined?(@email)
        options[:subject] = @email.subject
      end
    end
  end
end
