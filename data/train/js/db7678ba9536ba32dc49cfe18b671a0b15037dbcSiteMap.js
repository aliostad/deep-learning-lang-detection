dojo.provide("app.SiteMap");

app.SiteMap = [
  {
    pattern: "#login",
    controllers: [
      {controller: "app.controller.member.LoginController" }
    ]
  },
  {
    pattern: "#hand",
    controllers: [
      { controller: "app.controller.player.HandController" }
    ]
  },
  {
    pattern: "#chat-widget",
    controllers: [
      { controller: "app.controller.chat.ChatController" }
    ]
    
  },
  {
    pattern: "#friends",
    controllers: [
      { controller: "app.controller.member.FriendsController" }
    ]
  },
  
  {
    pattern: ".tappable",
    controllers: [
      { controller: "app.controller.card.TappableController" }
    ]
  }
];