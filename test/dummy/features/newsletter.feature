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
    Then I should see "title" within "#goldencobra-newsletter-registration-form"
    And I should see "first_name" within "#goldencobra-newsletter-registration-form"
    And I should see "last_name" within "#goldencobra-newsletter-registration-form"
    And I should see "company" within "#goldencobra-newsletter-registration-form"
    And I should see "phone" within "#goldencobra-newsletter-registration-form"
    And I should see "email" within "#goldencobra-newsletter-registration-form"

  @javascript
  Scenario: Successfully register for a newsletter
    And the following "articles" exist:
      | title               | url_name            | teaser         | content                    | id | active | newsletter |
      | "Dies ist ein Test" | dies-ist-ein-test-2 | "Die kleine …" | "Die kleine Maus wandert." |  2 | true   |   true     |
    When I go to the article page "dies-ist-ein-test-2"
    Then I choose "gender_female"
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
    Then I choose "gender_female"
    And I fill in "first_name" with "Michaela"
    And I fill in "last_name" with "Mustermann"
    When I press "Eintragen"
    Then I should see "Nicht erfolgreich."
