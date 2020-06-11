(ns sarah-website.sookasa
  (:require [sarah-website.recos :as recos]
            [sarah-website.work :as work]
            [sarah-website.footer :as footer]
            [sarah-website.nav :as nav]))

(def sookasa-case
  [:div.container-lrg
    [:h1.center "Sookasa People Tab Redesign"]
    [:section
      [:div.flex
        [:div.container-sml
          [:p "This piece was originally written for the Sookasa blog"]
          [:p "Sookasa enables companies to use the tools they love, like Dropbox and Google Drive, while remaining secure and compliant. We believe it’s essential in an industry like ours to rely on user-centered design: For something as sensitive (and complex) as securing data, providing a seamless experience helps customers feel confident and empowered. A few months ago, the Product team realized it was time to rethink how the various features on our app come together. As a lean customer-driven startup, we’re rapidly adding features our users need and want for their work. But this adds a lot of complexity to our app, and since we launched publicly in April 2014, we hadn’t yet optimized how all our new features came together."]
          [:div
            [:img {:src "https://saraharnegard.files.wordpress.com/2017/06/old-people-tab.png", :alt "old-people-tab"}]
            [:p "The old version of the people tab"]]
          [:p "We decided to begin with the People tab. In many ways, this is the most important part of our app for administrators. Fundamentally, Sookasa is a different kind of security solution because it enables collaboration rather than restricts it.And it all starts on the People tab, which is the primary place to manage team and external sharing permissions. We knew the People tab was poorly organized — it was unclear how people were grouped, and difficult to find who admins were looking for. It needed to change."]
          [:p "To learn how to approach the redesign, we sat down with customers who manage teams on Sookasa. Talking to customers is at the core of our design process: We have to understand their workflows in order to understand the problems that existed with the People tab. Through our research, we identified four main types of people that team admins manage: team members; peoplewho have been added to their team, but don’t have active accounts; external partners, and external partners who have not accepted an invite to join Sookasa."]

          [:p "The old design had shied away from being explicit about these distinctions, in part because we feared the differences weren’t well understood by users. Through testing, however, we discovered we couldn’t have been more wrong. These distinctions were integral to the way users interact with the product. And not only did the current design make it difficult to discern who fit into each category, it was also too disorganized."]

          [:p "After all, a lot has to happen on the People tab: We could see that users relied on the People tab to check who was on their team, track account setup progress, as well as oversee external partners. Beyond that, they needed to be able easily remove and add people, grant permissions to  team members, block devices from accessing data, and more."]
          [:p "So armed with insight into how users interacted with the tab—and what they needed—it was time to actually generate designs based on our customers’ needs."]
          [:img {:src "https://saraharnegard.files.wordpress.com/2017/06/paper-prototypes.png", :alt "paper prototypes"}]
          [:p "I created a series of prototypes that incorporated the main features we’d need and captured the various types of users. I used paper, pen, and scissors to create paper prototypes. Paper prototypes allowed for faster iteration because they are faster to create, and I could respond and adapt to feedback on the fly."]
          [:img {:src "img/sookasa/prototypes.png", :alt "digital prototypes"}]
          [:p "Digital prototypes"]
          [:p "I tested with all sorts of people: users who were pretty new to Sookasa, longtime customers, and people in coffee shops (in other words, people who  were totally unfamiliar with the product)."]
          [:p "As designer, I’m immersed in the product and the work I create. Feedback from outsiders is essential to the process of creating an intuitive learnable app design. It’s not enough for it to look beautiful or work for my colleagues and me."]


          [:p "The insight I gathered gave direction to new iterations and prototypes and identified other parts of the page that were confusing to users. I typically gather feedback by giving people common tasks in the interface. But mostly, I’m asking lots of questions."]

          [:p "It was through this process that I uncovered that integrating the four collaborator types into combined tables made the concepts even more confusing. It was totally unclear why certain people had different information displayed."]
          [:p "
            It was a lightbulb moment for me.]

            People seemed to need a design in which groups were clearly separated, not simply filtered or sorted by group.

            In response, I created a prototype of a tabbed design with people differentiated two ways: First into the two main collaborator types (team and partner), and then into those who were current users and pending.

            After dozens of prototypes and even more discovery interviews, we finally had a design that clicked. New testers and existing customers understood it right away."]
          [:img {:src "https://saraharnegard.files.wordpress.com/2017/06/screenshot.png", :alt "screenshot"}]
          [:p "Our People tab feels easy and obvious now, but that belies the effort that customer-centric design techniques demand. It seems like a simple feature, but simplicity takes a lot of work. Our customer-focused design techniques also gave us confidence as we rolled out the new design to all of our users. We weren’t biting our fingernails wondering how it’d be received; we knew the revamped People tab would improve the workflow of administrators before it even launched.I’m extremely proud about what we were able to achieve, but it’s not the end. We’ll be improving the page as we gain more insights, just like we do with every other feature."]]]]])


(defn content[]
  [:div
    [:header.header nav/hiccup]
    sookasa-case
    footer/hiccup])
