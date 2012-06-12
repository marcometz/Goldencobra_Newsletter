Feature: Display newsletter module and register for newsletters
  In order to register for a newsletter
  As an admin
  I want to decide wether to display the newsletter module

  Background:
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "articles" exist:
      | title               | url_name          | teaser         | content                    | id | active |
      | "Dies ist ein Test" | dies-ist-ein-test | "Die kleine …" | "Die kleine Maus wandert." |  1 | true   |

  Scenario: Go to the articles admin site and enable the newsletter module
    When I go to the admin list of articles
    Then I should see "Articles"
    When I click on "Edit" within "tr#article_1"
    Then I should see "Newsletter einblenden"
    When I check "article_newsletter"
    And I press "Speichern"
    And I go to the article page "dies-ist-ein-test"
    Then I should see "Title" within "#goldencobra-newsletter-registration-form"
    And I should see "firstname" within "#goldencobra-newsletter-registration-form"
    And I should see "lastname" within "#goldencobra-newsletter-registration-form"
    And I should see "Company" within "#goldencobra-newsletter-registration-form"
    And I should see "Phone" within "#goldencobra-newsletter-registration-form"
    And I should see "email" within "#goldencobra-newsletter-registration-form"

  @javascript
  Scenario: Register for newsletter within newsletter widget
    Given the following "articles" exist:
      | title               | url_name            | teaser         | content                    | id | active | newsletter |
      | "Dies ist ein Test" | dies-ist-ein-test-3 | "Die kleine …" | "Die kleine Maus wandert." |  3 | true   | false      |
    And the following "widgets" exist:
      | title |            content                       | article_ids | active |
      | news  | {% newsletter_form monthly_newsletter %} |  3          |  true  |
    And the following "email_templates" exist:
      | template_tag       | content_html |
      | monthly_newsletter | content      |
    When I go to the article page "dies-ist-ein-test-3"
    Then I choose "gender_1"
    And I fill in "firstname" with "Michaela"
    And I fill in "lastname" with "Mustermann"
    And I fill in "Company" with "Mustercompany"
    And I fill in "Phone" with "030 123 456 789"
    And I fill in "email" with "michaela@mustermann.de"
    When I press "Eintragen"
    #Then I should see "Erfolgreich eingetragen"

    # Because of double-opt-in you don't get a registration right away
    #When I go to the admin list of newsletter_registrations
    #Then I should see "monthly_newsletter"
 
  @javascript
  Scenario: Successfully register for a newsletter
    And the following "articles" exist:
      | title               | url_name            | teaser         | content                    | id | active | newsletter |
      | "Dies ist ein Test" | dies-ist-ein-test-2 | "Die kleine …" | "Die kleine Maus wandert." |  2 | true   |   true     |
    When I go to the article page "dies-ist-ein-test-2"
    Then I choose "gender_0"
    And I fill in "first_name" with "Michaela"
    And I fill in "last_name" with "Mustermann"
    And I fill in "company" with "Mustercompany"
    And I fill in "phone" with "030 123 456 789"
    And I fill in "email" with "michaela@mustermann.de"
    When I press "Eintragen"
    Then I should see "Erfolgreich eingetragen"
    When I go to the admin list of newsletter_registrations
    Then I should see "Michaela Mustermann"
    And I should see "michaela@mustermann.de"
    And I should see "Mustercompany"
    And I should see "true"

  @javascript
  Scenario: Unsuccessfully register for a newsletter
    And the following "articles" exist:
      | title               | url_name            | teaser         | content                    | id | active | newsletter |
      | "Dies ist ein Test" | dies-ist-ein-test-3 | "Die kleine …" | "Die kleine Maus wandert." |  3 | true   |   true     |
    When I go to the article page "dies-ist-ein-test-3"
    Then I choose "gender_0"
    And I fill in "first_name" with "Michaela"
    And I fill in "last_name" with "Mustermann"
    And I fill in "email" with "michaela"
    When I press "Eintragen"
    Then I should see "Nicht erfolgreich."

  @javascript
  @email
@wip
  Scenario: Send email to newsletter recipients
    Given the following "guest_users" exist:
      | firstname | lastname | email            | password | password_confirmation | id |
      | Timothy   | Thetest  | holger@ikusei.de | 123456   | 123456                |  3 |
    And the following "newsletter_registrations" exist:
      | user_id | company_name | is_subscriber |
      |    3    | ikusei       |  true         |
    And the following "email_templates" exist:
      | content_html                | content_txt      | title                 | subject                |
      | <div>Emails are great</div> | Emails are great | Newsletters are great | Awesome Email incoming |
    When I go to the admin list of newsletter_registrations
    Then I should see "newsletter registrations"
    When I check "collection_selection_toggle_all"
    And I click on "Batch Actions"
    And I click on "E-Mail senden: Newsletters are great"
