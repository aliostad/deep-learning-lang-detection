class MainNavigation

  ITEMS = [
    {
      title: 'Maker',
      controller: Maker::ConceptsController,
      children: [
        {
          title: 'Topics',
          controller: Maker::TopicsController
        },
        {
          title: 'Concepts',
          controller: Maker::ConceptsController
        },
        {
          title: 'Traits',
          controller: Maker::TraitsController
        },
        {
          title: 'Skills',
          controller: Maker::SkillsController
        },
        {
          title: 'Bundles',
          controller: Maker::BundlesController
        },
        {
          title: 'Items',
          controller: Maker::ItemsController
        },
        {
          title: 'TraitValue',
          controller: Maker::TraitValuesController
        }
      ]
    },
    {
      title: 'Me',
      controller: Me::ActorsController,
      children: [
        {
          title: 'Actors',
          controller: Me::ActorsController
        },
        {
          title: 'Contributions',
          controller: Me::ContributionsController
        }
      ]
    },
    {
      title: 'RawNode',
      controller: RawNode::NodesController
    }
  ]

  def self.items
    ITEMS
  end
end
