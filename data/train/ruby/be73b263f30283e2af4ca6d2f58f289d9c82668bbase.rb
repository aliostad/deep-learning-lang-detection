require "grape-swagger"

module API
  module V1
    class Base < Grape::API
      mount API::V1::Users
      mount API::V1::Works
      mount API::V1::Questions
      mount API::V1::Favorites
      mount API::V1::Squares
      mount API::V1::Reports
      mount API::V1::GrammarTypes
      mount API::V1::GrammarGroups
      mount API::V1::GrammarFootprints
      mount API::V1::GrammarResults
      mount API::V1::VocabularyGroups
      mount API::V1::VocabularyResults
      mount API::V1::VocabularyFootprints
      mount API::V1::VocabularyRates
      mount API::V1::Articles
      mount API::V1::ArticleMarks
      mount API::V1::Speeches
      #mount API::V1::ArticleJudgements
      mount API::V1::OralGroups
      mount API::V1::OralResults
      mount API::V1::JinghuaQuestions
      mount API::V1::JinghuaAnswers
      mount API::V1::JinghuaMarks
      mount API::V1::JinghuaSamples
      #mount API::V1::JinghuaJudgements
      mount API::V1::Profiles
      mount API::V1::Feedbacks
      mount API::V1::ReproductionQuestions
      mount API::V1::ReproductionResults
      mount API::V1::OralOrigins
      mount API::V1::Oral2Results
      mount API::V1::JijingGroups
      mount API::V1::JijingQuestions
      mount API::V1::JijingSamples
      mount API::V1::JijingAnswers
      mount API::V1::JijingMarks
      mount API::V1::JijingMarks
      #mount API::V1::JijingJudgements
      mount API::V1::TpoGroups
      mount API::V1::TpoQuestions
      mount API::V1::TpoJudgements
      mount API::V1::DictationGroups
      mount API::V1::DictationQuestions
      mount API::V1::DictationResults
      mount API::V1::DictationFootprints
      mount API::V1::Messages
      mount API::V1::HotExercises


      add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: "/api/v1/swagger_doc",
        hide_format: true
      )
    end
  end
end
